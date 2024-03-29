---
title: Ужасный, ужасный Terraform
date: 2024-02-21 12:20 UTC
tags: terraform, clean_code
---
<p align="center">
    <img src="/images/terraform-the-terrible.png">
</p>

Несколько лет назад я познакомился с инструментом управления инфраструктурой как кодом Terraform. Признаться честно, для меня Terraform был открытием примерно как Docker в 2014 году. Что Docker, что Terraform решают миллион неочевидных проблем с кодом, что ты пишешь каждый день. Docker позволяет без боли запускать твой код на компьютере с линуксом твоего коллеги, а Terraform позволяет без боли сделать инфраструктуру для твоего проекта в продакшене. И Docker и Terraform так или иначе крутятся вокруг git: один использует его push/pull модель, второй идеологически наследует работу с diff'ами. В общем, у меня в голове сразу появилась картинка, как сильно Terraform поможет в ежедневных процессах работы с инфраструктурой. Сразу же нарисовались воображаемые пайплайны CI-CD, которые всегда были зелеными и в них не было никаких ошибок.

Я перепробовал большое количество Terraform-провайдеров, от клаудов вроде GCP/AWS/Alicloud и систем виртуализации Proxmox/VMware/Canonical MAAS до систем вроде Akamai/Cloudflare/GCore/NS1 и рождественского дерева (да-да, такой провайдер [существует](https://registry.terraform.io/providers/cappyzawa/christmas-tree/latest)). В основном, я начинал с экспериментов в домашней лаборатории с Proxmox. Большое количество провайдеров, документации, статей очень сильно воодушевило. А возможность того, что тебе больше не надо тыкать мышкой в неудобный GUI, привела меня в восторг. Как будто бы мне лет шестнадцать и я впервые установил Linux :) 

Однако, очарование довольно быстро развеялось о суровую реальность. То, что восторженно пишут авторы на Medium в небольших пятиминутных статьях обычно остается в рамках пятиминутных статей. Как часто бывает, красивый сюжет истории и ожидаемый хэппи-энд мало относится к реальной жизни. Хэппи-энды не обязаны появляться в реальной жизни. А когда это осознаешь, частенько бывает, что с этим ничего не поделать. 

Terraform не исключение. Посмотрев достаточно примеров, я выявил несколько неявных паттернов, которые могут со временем заставить плакать кровавыми слезами, глядя на красивый (казалось бы) репозиторий с Terraform-кодом. Следуя им, можно полностью убедиться, что Terraform скорее деструктивный, чем удобный инструмент, облегчающий ежедневные задачи.

### Паттерны плохих Terraform проектов

### 1. Не читать документацию до написания Terraform кода

Это примерно как с айти-курсами: поверхностно глянул и уже думаешь, что можешь всё. Простота использования Terraform очень сильно подкупает: нужен (условно) один API-token и вот ты уже на кончиках пальцев можешь играть своей инфраструктурой. Plan вправо, apply влево и ты уже повелитель пайплайнов. Эта простота и быстрость заставляет тебя делать больше, больше и больше, не задумываясь о качестве и переносимости кода. Да и зачем волноваться? Ctrl-c, Ctrl-v, и бах — закрыл десяток тикетов. Удобно же? 

Вовремя прочитанная документация по Terraform позволит сохранить огромное количество времени и нервов (а иногда и денег). Почему если ещё недавно все следовали правилу RTFM, то с Terraform вдруг его позабыли?


### 2. Infrastructure as Code, но без кода
   
   Увы, излишняя простота может заставить подумать о том, что большинство вещей, описанных в документации (например, темплейты, модули, условия, циклы) -- не нужны. К чему такое приводит? Появляется излишний лапша-код, неструктурированный и плохочитаемый. Это приводит к тому, что со временем менеджерить однотипные ресурсы станет просто невозможно. Их количество и размер в строках кода в какой-то момент не могут поместиться во внимании инженера, кому нужно сделать качественные изменения. Если обычный код живет как вещь в себе и не так уж сильно влияет на сущности вокруг себя (кроме кода), то Terraform влияет на инфраструктуру напрямую. Совершить ошибку в виде глупой опечатки при наличии огромного количество похожего Terraform кода очень легко. Более того, сам Terraform зачастую не является валидатором корректности твоих ресурсов. Во многих провайдерах и системах проверка на валидность создаваемых ресурсов проводится непосредственно во время Terraform apply, что ещё больше усложняет понимание того, что же на самом деле делает твой код. Поэтому полезно напоминать себе о том, что в аббревиатуре "Infrastructure as Code" слово Code имеет такой же приоритет, как и Infrastructure.

### 3. Не думать об архитектуре
   
   Что происходит когда мало времени, а инфраструктуру нужно запустить ещё вчера? Опустим менеджерские вопросы. 
   
   Логичный ответ -- берёшь и делаешь. Используешь подходы, которые максимально быстро помогут решить задачу: много копипасты, если что-то надо сделать руками, а в Terraform не получается -- делаешь руками. Пренебрегаешь полными настройками флоу выкатки Terraform ресурсов. 
   
   Что происходит на следующий день? Тоже самое. И на следующий день происходит тоже самое. 
   
   Такая беготня приводит к тому, что через год-два твои проекты перестанут быть удобно поддерживаемыми. В какой-то момент не будет ни одного человека (включая тебя), который мог бы на пальцах обьяснить бизнес-правила, связанные с твоими ресурсами в Terraform. Почему к одним виртуальным машинам применён один набор сетевых ограничений, а к другим -- другой? А если надо запустить похожую инфраструктуру, но в другом окружении? Если количество ресурсов будет больше сотни, делать исправления в скопированном коде из другого проекта займет приличное количество времени. Если код рассредоточен по десяткам git-репозиториев с однотипной конфигурацией в разных регионах и окружениях, то количество однотипных мерж-реквестов увеличивается.
   
### 4. Что-то не получается? Сделаем руками, а потом перенесём в Terraform стейт
   
   Ну а тут-то что может пойти не так? Что не так с тем, чтобы сделать несколько ресурсов/правил/etc руками, а потом сделать terraform import? 
   
   Соглашусь, что как временное решение на одну текущую задачу такой подход существенно сэкономит time to market инфраструктуры. Но когда таких маленьких задач становится слишком много, допустим, сотня, то переносить конфигурацию таких однотипных ресурсов в Terraform стейт -- утомительно. Кажется, что время на эту ручную работу можно потратить на более полезные вещи.
   
   Так что, если есть возможность начинать инфраструктурные проекты с нуля, лучше начинать проект сразу с Terraform кода. Гораздо проще работать с инфраструктурой, изначально запущенной c Terraform, чем тратить часы на монотонные операции по импорту ресурсов в Terraform стейт. Если это ещё и делать медленно, то часть ресурсов будет менеджериться Terraform кодом, а часть вручную. Как-то это не выглядит привлекательно, если одна из наших целей как инженеров управлять инфраструктурой с помощью кода.
   
### 5. Best-practices? Зачем?
   
   KISS, YAGNI, single-responsibility? Задачи горят. Некогда. Когда будем рефакторить? Давай подумаем об этом потом. Рефакторинг бизнесу не продашь. Тесты писать долго? Давай вообще не будем пока.

> Конечно, ситуация когда все пять пунктов совпали в одном проекте маловероятная. По-крайней мере, я очень на это надеюсь. Но тем не менее, отдельные пункты вполне могут так или иначе всплывать на поверхность.

### Что же со всем этим делать? 

Инвестировать время (если не получается рабочее, то личное) на изучение инструмента, и думать о том, как рационально использовать best-practices. Terraform имеет отличнейшую документацию, написанную талантливыми инженерами. Кроме документации, есть ещё огромное количество статей, гайдов и прочих практикумов. Неплохо бы ещё вспомнить книжку [дяди Боба](https://www.oreilly.com/library/view/clean-code-a/9780136083238/) и [Twelve Factor App](https://12factor.net/). Запустить домашнюю лабораторию для работы с системой виртуализации или ещё чем-нибудь. Пробовать в этой лаборатории создавать, редактировать и удалять Terraform ресурсы, чтобы иметь уверенность в своём коде.

Всё-таки, Terraform не такой большой rocket-science. И эти усилия стопроцентно окупятся на большой дистанции.