---
title: "Saturday evening project: Building a minimal Kubernetes CSI driver from scratch"
title_ru: "Проект на субботний вечер: Пишем минимальный CSI-драйвер для Kubernetes с нуля"
title_en:
date: 2026-06-06 19:03 UTC
tags: kubernetes, k8s, golang
---

<div data-translation-content="ru" markdown="1">

Давненько у меня не было никаких "личных" субботних хакатончиков, хотя [ранее](https://www.dronov.net/2017/03/13/how-to-best-at-hardathone.html) они были не только по субботним вечерам. После недолгих размышений было принято решение попробовать то, о чём давно чесались руки: написать небольшой CSI-driver для Kubernetes.

<p align="center">
    <img src="/images/csi.png">
</p>

### Зачем?

Это небольшой проект для углубления знаний о том, как внутри работает Kubernetes. У меня нет цели собрать полноценный драйвер и зачем-то его выпускать и использовать. Можно было просто ознакомиться с официальным [примером драйвера](https://github.com/kubernetes-csi/csi-driver-host-path), но мне хотелось пописать код. Так и появился мой [minimal CSI driver](https://github.com/dronov/minimal-csi-driver).

### Документация и требуемое окружение

* [Документация Kubernetes](https://kubernetes-csi.github.io/docs/)
* [Пример Hostpath CSI driver](https://kubernetes-csi.github.io/docs/example.html)
* [Github Hostpath CSI driver](https://github.com/kubernetes-csi/csi-driver-host-path)
* Основу кода писал по [статье Nawaz Dhandala](https://oneuptime.com/blog/post/2026-02-09-write-minimal-csi-driver-kubernetes/view)
* Драйвер запускал в [kind](https://kind.sigs.k8s.io/)

### Кратко о CSI-драйвере

Интерфейс CSI абстрагирует логику работы со слоем хранения данных от самого ядра Kubernetes. Полноценный CSI-драйвер состоит из трех основных gRPC-компонентов:

* Identity Service: Возвращает общую информацию о драйвере (его имя, версию и поддерживаемые возможности). Используется Kubernetes для проверки готовности плагина.
* Controller Plugin: Отвечает за глобальные операции с томами: создание/удаление, а также за прикрепление тома к конкретному узлу (Attach и/ Detach). Обычно деплоится как одиночный под.
* Node Plugin: Выполняется на каждом конкретном воркер-ноде в виде DaemonSet. Отвечает за непосредственное форматирование, монтирование и размонтирование дисков в файловую систему, к которой у контейнеров будет доступ.

### Proof of concept

Для проверки нашего драйвера мы создадим файлик в примаунченном волуме и попробуем [записать файл](https://github.com/dronov/minimal-csi-driver/blob/main/deploy/kubernetes/workload.yaml#L37).

[workload.yaml](https://github.com/dronov/minimal-csi-driver/blob/main/deploy/kubernetes/workload.yaml#L37)
<pre><code>
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: minimal-csi
provisioner: minimal.csi.dronov.net
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: false
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: minimal-csi-test
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: minimal-csi
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: minimal-csi-test
  namespace: default
spec:
  restartPolicy: Never
  containers:
    - name: test
      image: busybox:1.37
      command:
        - /bin/sh
        - -c
        - |
          set -eu
          echo "minimal CSI driver works" | tee /data/result.txt
          test "$(cat /data/result.txt)" = "minimal CSI driver works"
          ls -la /data
          sleep 3600
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: minimal-csi-test
</code></pre>

### Пишем код
Структура проекта описана в  [оригинальной статье](https://oneuptime.com/blog/post/2024-02-09-write-minimal-csi-driver-kubernetes/view). Но при сборке проекта я столкнулся с первой сложностью:

```
# github.com/kubernetes-csi/drivers/pkg/csi-common
/home/mesh/go/pkg/mod/github.com/kubernetes-csi/drivers@v1.0.0/pkg/csi-common/utils.go:76:20: cannot use ids (variable of type *DefaultIdentityServer) as csi.IdentityServer value in argument to s.Start: *DefaultIdentityServer does not implement csi.IdentityServer (missing method mustEmbedUnimplementedIdentityServer)
/home/mesh/go/pkg/mod/github.com/kubernetes-csi/drivers@v1.0.0/pkg/csi-common/utils.go:84:20: cannot use ids (variable of type *DefaultIdentityServer) as csi.IdentityServer value in argument to s.Start: *DefaultIdentityServer does not implement csi.IdentityServer (missing method mustEmbedUnimplementedIdentityServer)
/home/mesh/go/pkg/mod/github.com/kubernetes-csi/drivers@v1.0.0/pkg/csi-common/utils.go:92:20: cannot use ids (variable of type *DefaultIdentityServer) as csi.IdentityServer value in argument to s.Start: *DefaultIdentityServer does not implement csi.IdentityServer (missing method mustEmbedUnimplementedIdentityServer)
```

Оказалось, это ошибка оригинального кода из-за старого csi-common версии v1.0.0 и новой спеки CSI, где серверные интерфейсы требуют ```mustEmbedUnimplementedIdentityServer```. Пришлось поправить это, запустив gRPC сервер [явно](https://github.com/dronov/minimal-csi-driver/blob/main/cmd/driver/main.go#L62).

Далее, произошло следующее:
* Как оказалось, я сделал несколько опечаток в виде неверных имён ```serviceAccountName``` в driver.yaml
* Решил не использовать ghcr.io из-за 401 при пулле образа, а заливать в kind напрямую
* Драйвер валился с ошибкой ```invalid endpoint: only unix:// endpoints are supported```, поэтому пришлось также поправить написание сокета в коде

#### Важное техническое допущение

В ```NodePublishVolume``` мы не используем внешнее хранилище, а просто [пишем в директорию на ноде, которую предоставил kubelet](https://github.com/dronov/minimal-csi-driver/blob/main/pkg/driver/node.go#L33). Затем kubernetes предоставляет этот каталог для пода в качестве точки монтирования (тома, но тома как такового нет). Изначально я, как и автор оригинальной статьи, не думал о Ceph, NFS и реализации хранения данных где-то в сети.

##### Билдим бинарь

```
mkdir -p bin CGO_ENABLED=0 GOOS=linux go build -o bin/minimal-csi-driver cmd/driver/main.go
```

##### Собираем имейдж и заливаем в kind

```
docker build -t minimal-csi-driver:local .
kind load docker-image minimal-csi-driver:local --name kind
```

##### Деплоим драйвер в kind

Создадим StorageClass, PVC, Pod

```
kubectl apply -f deploy/kubernetes/rbac.yaml
kubectl apply -f deploy/kubernetes/driver.yaml
```

##### Проверяем сетап драйвера

```
kubectl apply -f deploy/kubernetes/workload.yaml
kubectl get csidriver
kubectl get storageclass
kubectl get pvc,pv
kubectl get pod minimal-csi-test -o wide
```

Что хочется видеть в stdout:

<pre><code>- PVC: Bound
- PV: Bound
- Pod: Running</code></pre>

##### Проверяем

Для проверки запустим busybox, который создаст result.txt:

<pre><code>~/w/m/g/minimal-csi-driver  main [!?✔] ⎈ kind-kind
❯ kubectl exec minimal-csi-test -- cat /data/result.txt
minimal CSI driver works

~/w/m/g/minimal-csi-driver  main [!?✔] ⎈ kind-kind
❯ kubectl logs minimal-csi-test
minimal CSI driver works
total 12
drwxr-xr-x    2 root     root          4096 Jun  6 18:26 .
drwxr-xr-x    1 root     root          4096 Jun  6 18:26 ..
-rw-r--r--    1 root     root            25 Jun  6 18:26 result.txt</code></pre>

Ура! Драйвер запустился, и мы в поде видим желаемый result.txt.

Проверим, действительно ли файл появился у нас на ноде в Kind:

<pre><code>~/w/m/g/minimal-csi-driver  main [✔] ⎈ kind-kind
❯ kubectl get pod minimal-csi-test -o jsonpath='{.metadata.uid}{"\n"}'
50c0d2a8-dc01-4cd6-b6f3-944425aafc29

~/w/m/g/minimal-csi-driver  main [✔] ⎈ kind-kind
❯ docker exec -it kind-control-plane bash
root@kind-control-plane:/# cd /var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi/
root@kind-control-plane:/var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi# find . -name result.txt
./pvc-5a6b9c1d-5eab-4eca-b077-16390887f8d9/mount/result.txt
root@kind-control-plane:/var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi# cat ./pvc-5a6b9c1d-5eab-4eca-b077-16390887f8d9/mount/result.txt
minimal CSI driver works
root@kind-control-plane:/var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi# exit
exit

~/w/m/g/minimal-csi-driver  main [✔] ⎈ kind-kind
❯</code></pre>

### Что дальше?

Главный экзистенциальный вопрос: что именно мы будем использовать в качестве стораджа у данных ворклоадов? В документации описана минимальность функциональность production-ready драйвера: доделать реальное монтирование волумов, добавить поддержку снапшотов, изменения размера и многое другое.

Но для вечера субботы это уже слишком большая задача :)

</div>

<div data-translation-content="en" markdown="1" hidden>

I haven't had any of 'personal' Saturday's hackathons for a while, though they [used to be](https://www.dronov.net/2017/03/13/how-to-best-at-hackathon.html) a lot more frequent than just on Saturdays. After a few moments of thinking, I decided to tinker with something I've wanted for a while and write a small Kubernetes CSI driver.

<p align="center">
    <img src="/images/csi.png">
</p>

### Зачем?

This is just a small project to get a deeper understanding of how Kubernetes works under the hood. I have no intention of building a full-blown driver to actually release or use. I could have just checked out the official [host-path driver example](https://github.com/kubernetes-csi/csi-driver-host-path), but I wanted to write some code by myself. And that's how my [minimal CSI driver](https://github.com/dronov/minimal-csi-driver) came to life.

### Documentation and necessary environment

* [Kubernetes documentation](https://kubernetes-csi.github.io/docs/)
* [Official example of a Hostpath CSI driver](https://kubernetes-csi.github.io/docs/example.html)
* [Github Hostpath CSI driver](https://github.com/kubernetes-csi/csi-driver-host-path)
* The code is based on [an article of Nawaz Dhandala](https://oneuptime.com/blog/post/2026-02-09-write-minimal-csi-driver-kubernetes/view)
* Driver is deployed into a [kind](https://kind.sigs.k8s.io/)

### CSI-driver in a few words

The CSI interface separates the storage logic from the core Kubernetes code. A full CSI driver relies on three main gRPC components:

* Identity Service: Returns basic info about the driver (its name, version, and capabilities). Kubernetes uses it to check if the plugin is ready.
* Controller Plugin: Handles global volume operations like creating or deleting volumes, as well as attaching and detaching them to specific nodes. It usually runs as a single pod.
* Node Plugin: Runs on every worker node as a DaemonSet. It takes care of formatting, mounting, and unmounting disks right into the file system so containers can access them.

### Proof of concept

To test our driver, we will create a file inside the mounted volume and try to [write some data into it](https://github.com/dronov/minimal-csi-driver/blob/main/deploy/kubernetes/workload.yaml#L37).

[workload.yaml](https://github.com/dronov/minimal-csi-driver/blob/main/deploy/kubernetes/workload.yaml#L37)
<pre><code>
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: minimal-csi
provisioner: minimal.csi.dronov.net
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: false
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: minimal-csi-test
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: minimal-csi
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: minimal-csi-test
  namespace: default
spec:
  restartPolicy: Never
  containers:
    - name: test
      image: busybox:1.37
      command:
        - /bin/sh
        - -c
        - |
          set -eu
          echo "minimal CSI driver works" | tee /data/result.txt
          test "$(cat /data/result.txt)" = "minimal CSI driver works"
          ls -la /data
          sleep 3600
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: minimal-csi-test
</code></pre>

### Writing the code
The project structure is described in the [original article](https://oneuptime.com/blog/post/2024-02-09-write-minimal-csi-driver-kubernetes/view). However I ran into my first issue while trying to build it:

```
# github.com/kubernetes-csi/drivers/pkg/csi-common
/home/mesh/go/pkg/mod/github.com/kubernetes-csi/drivers@v1.0.0/pkg/csi-common/utils.go:76:20: cannot use ids (variable of type *DefaultIdentityServer) as csi.IdentityServer value in argument to s.Start: *DefaultIdentityServer does not implement csi.IdentityServer (missing method mustEmbedUnimplementedIdentityServer)
/home/mesh/go/pkg/mod/github.com/kubernetes-csi/drivers@v1.0.0/pkg/csi-common/utils.go:84:20: cannot use ids (variable of type *DefaultIdentityServer) as csi.IdentityServer value in argument to s.Start: *DefaultIdentityServer does not implement csi.IdentityServer (missing method mustEmbedUnimplementedIdentityServer)
/home/mesh/go/pkg/mod/github.com/kubernetes-csi/drivers@v1.0.0/pkg/csi-common/utils.go:92:20: cannot use ids (variable of type *DefaultIdentityServer) as csi.IdentityServer value in argument to s.Start: *DefaultIdentityServer does not implement csi.IdentityServer (missing method mustEmbedUnimplementedIdentityServer)
```

It turned out that the original code had a compability issue with the old csi-common v1.0.0 and the newer CSI specification, where server interfaces require  ```mustEmbedUnimplementedIdentityServer```. I fixed it by starting the gRPC server [directly](https://github.com/dronov/minimal-csi-driver/blob/main/cmd/driver/main.go#L62).

Then I ran into a few more issues:
* I had made several typos in the ```serviceAccountName``` value in driver.yaml
* I decided not to use ghcr.io cause pulling the image returned 401 error and I loaded the image directly into kind
* The driver crashed with ```invalid endpoint: only unix:// endpoints are supported```, so I also fixed how the socked endpoint is defined in the code

#### Important technical limitation

In ```NodePublishVolume``` we do not use an external storage. We simply [write to a directory on the node provided by kubelet](https://github.com/dronov/minimal-csi-driver/blob/main/pkg/driver/node.go#L33). Kubernetes then exposes that directory to the Pod as the requested volume mount.
At first, like the author of the original article, I did not consider using Ceph, NFS, or storing data somewhere over the network.

##### Build the binary

```
mkdir -p bin CGO_ENABLED=0 GOOS=linux go build -o bin/minimal-csi-driver cmd/driver/main.go
```

##### Build the image and upload to kind

```
docker build -t minimal-csi-driver:local .
kind load docker-image minimal-csi-driver:local --name kind
```

##### Deploy the driver kind

Let's create a StorageClass, a PVC, and a Pod

```
kubectl apply -f deploy/kubernetes/rbac.yaml
kubectl apply -f deploy/kubernetes/driver.yaml
```

##### Verify the driver installation

```
kubectl apply -f deploy/kubernetes/workload.yaml
kubectl get csidriver
kubectl get storageclass
kubectl get pvc,pv
kubectl get pod minimal-csi-test -o wide
```

What is expected to see in stdout:

<pre><code>- PVC: Bound
- PV: Bound
- Pod: Running</code></pre>

##### Final verification

To test it we will run a BusyBox container that creates result.txt:

<pre><code>~/w/m/g/minimal-csi-driver  main [!?✔] ⎈ kind-kind
❯ kubectl exec minimal-csi-test -- cat /data/result.txt
minimal CSI driver works

~/w/m/g/minimal-csi-driver  main [!?✔] ⎈ kind-kind
❯ kubectl logs minimal-csi-test
minimal CSI driver works
total 12
drwxr-xr-x    2 root     root          4096 Jun  6 18:26 .
drwxr-xr-x    1 root     root          4096 Jun  6 18:26 ..
-rw-r--r--    1 root     root            25 Jun  6 18:26 result.txt</code></pre>

Great! The driver is running and we can see the expected result.txt inside the Pod.

Now let's check whether the file actually appeared on the Kind node:

<pre><code>~/w/m/g/minimal-csi-driver  main [✔] ⎈ kind-kind
❯ kubectl get pod minimal-csi-test -o jsonpath='{.metadata.uid}{"\n"}'
50c0d2a8-dc01-4cd6-b6f3-944425aafc29

~/w/m/g/minimal-csi-driver  main [✔] ⎈ kind-kind
❯ docker exec -it kind-control-plane bash
root@kind-control-plane:/# cd /var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi/
root@kind-control-plane:/var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi# find . -name result.txt
./pvc-5a6b9c1d-5eab-4eca-b077-16390887f8d9/mount/result.txt
root@kind-control-plane:/var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi# cat ./pvc-5a6b9c1d-5eab-4eca-b077-16390887f8d9/mount/result.txt
minimal CSI driver works
root@kind-control-plane:/var/lib/kubelet/pods/50c0d2a8-dc01-4cd6-b6f3-944425aafc29/volumes/kubernetes.io~csi# exit
exit

~/w/m/g/minimal-csi-driver  main [✔] ⎈ kind-kind
❯</code></pre>

### What's next?

The main existential question is: what storage backend should we uyse for our workloads? The documentation describes the minimum functionality expected from a production-ready driver: implement real volume mounting, add support for snapshots and resizing and much more.

But this is already too much for a Saturday evening hackathon :)

</div>
