---
title: Ужасный, ужасный Terraform
title_ru: Ужасный, ужасный Terraform
title_en: Terraform, the terrible
date: 2024-02-21 12:20 UTC
tags: terraform, clean_code
---

<div data-translation-content="ru" markdown="1">

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

</div>

<div data-translation-content="en" markdown="1" hidden>

<p align="center">
    <img src="/images/terraform-the-terrible.png">
</p>


A few years ago, I got acquainted with the Infrastructure as Code tool called Terraform. To be honest, Terraform was a revelation for me, much like Docker was in 2014. Both Docker and Terraform address a myriad of subtle issues with the code you write every day. Docker allows painless deployment of your code on your colleague's Linux machine, and Terraform lets you painlessly create infrastructure for your project in production. Both Docker and Terraform, in one way or another, revolve around Git: one employs its push/pull model, while the other ideologically inherits the handling of diffs. In general, I immediately envisioned how much Terraform would assist in the day-to-day processes of working with infrastructure. Imaginary CI/CD pipelines appeared in my mind, always staying green with no errors.

I've tried a variety of Terraform providers, ranging from cloud providers like GCP/AWS/Alicloud and virtualization systems like Proxmox/VMware/Canonical MAAS to systems like Akamai/Cloudflare/GCore/NS1 and even a Christmas tree provider [exists](https://registry.terraform.io/providers/cappyzawa/christmas-tree/latest)). Primarily, I started experimenting in my home lab with Proxmox. The abundance of providers, documentation, and articles was very inspiring. The prospect of not having to click through an inconvenient GUI anymore thrilled me. It felt like I was sixteen again and had just installed Linux for the first time :)

However, the enchantment quickly dissipated into harsh reality. What authors enthusiastically write about on Medium in brief five-minute articles often remains within the confines of those short articles. As is often the case, a beautiful story plot and an expected happy ending have little to do with real life. Happy endings are not guaranteed in real life. And when you realize that, it's often the case that there's nothing you can do about it.

Terraform is no exception. After examining enough examples, I identified several implicit patterns that could eventually make you cry bloody tears when looking at a seemingly beautiful Terraform code repository. Following them, you might come to the conclusion that Terraform is more of a destructive than a convenient tool that facilitates daily tasks.

### Patterns of Bad Terraform Projects

### 1. Not reading the documentation before writing Terraform code

It's somewhat like with IT courses: glance over it superficially and already think you know it all. The ease of using Terraform is incredibly enticing: you need (hypothetically) just one API token, and voila, you can play with your infrastructure at your fingertips. Plan to the right, apply to the left, and you're already the master of pipelines. This simplicity and speed make you do more, more, and more without thinking about the quality and portability of the code. And why worry? Ctrl-c, Ctrl-v, and boom — closed a dozen tickets. Convenient, isn't it?

Reading the Terraform documentation in a timely manner can save a tremendous amount of time, nerves, and sometimes even money. Why is it that not long ago everyone followed the RTFM rule, but with Terraform, it seems to have been forgotten?


### 2. Infrastructure as Code, but without the code
   
Unfortunately, excessive simplicity can lead one to think that most things described in the documentation (such as templates, modules, conditions, loops) are unnecessary. Where does this lead? It results in unnecessary spaghetti code, unstructured and hard to read. This leads to the point where managing similar resources becomes nearly impossible over time. Their quantity and size in lines of code eventually become too overwhelming for an engineer trying to make meaningful changes. While regular code lives somewhat independently and doesn't significantly affect entities around it (except for the code itself), Terraform directly impacts the infrastructure. Making a mistake like a simple typo is easy with a vast amount of similar Terraform code. Moreover, Terraform often doesn't act as a validator for the correctness of your resources. In many providers and systems, validation of the created resources occurs directly during Terraform apply, further complicating the understanding of what your code is actually doing. Therefore, it's helpful to remind oneself that in the abbreviation "Infrastructure as Code," the word Code has the same priority as Infrastructure.

### 3. Not thinking about architecture
   
What happens when there's little time, but the infrastructure needs to be up and running yesterday? Let's set aside managerial issues.

The logical answer is you just go ahead and do it. You employ approaches that quickly help solve the task: lots of copy-pasting, manual interventions when something can't be done in Terraform, and neglecting the full setup of the Terraform resource rollout workflow.

What happens the next day? The same thing. And the day after that, the same thing occurs again.

This constant hustle leads to a situation where, after a year or two, your projects become challenging to maintain. At some point, there won't be a single person (including you) who can clearly explain the business rules associated with your Terraform resources. Why are certain network restrictions applied to some virtual machines and different ones to others? What if you need to deploy a similar infrastructure but in a different environment? With over a hundred resources, making changes in copied code from another project will take a considerable amount of time. If the code is spread across dozens of Git repositories with similar configurations in different regions and environments, the number of repetitive merge requests increases.
   
### 4. Having trouble with something? Let's do it manually, and then we'll transfer it to the Terraform state.
   
Well, what could go wrong here? What's wrong with creating a few resources/rules/etc manually and then using terraform import?

I agree that as a temporary solution for a specific current task, this approach significantly saves time to market for infrastructure. However, when there are too many of these small tasks, let's say a hundred, transferring the configuration of such similar resources to the Terraform state becomes tedious. It seems like the time spent on this manual work could be better utilized for more meaningful tasks.

So, if there's an opportunity to start infrastructure projects from scratch, it's better to begin the project directly with Terraform code. It's much easier to work with infrastructure initially launched with Terraform than to spend hours on monotonous import operations. If this process is done slowly, you end up managing some resources with Terraform code and others manually. This doesn't look appealing, especially if one of our goals as engineers is to manage infrastructure through code.
   
### 5. Best-practices? Why bother?
   
KISS, YAGNI, single-responsibility? Tasks are urgent. No time. When will we refactor? Let's think about it later. You can't sell refactoring to the business. Writing tests takes too long? Let's not bother with that for now.

> Sure, the scenario where all five points align in one project is unlikely. At least, I sincerely hope so. Nevertheless, individual points can still surface one way or another.

### What to do with all of this?

Invest time (if not work time, then personal time) in learning the tool and thinking about how to rationally apply best practices. Terraform has excellent documentation written by talented engineers. In addition to the documentation, there are numerous articles, guides, and practical workshops available. It wouldn't hurt to remember [Uncle Bob's book](https://www.oreilly.com/library/view/clean-code-a/9780136083238/) and [Twelve Factor App principles](https://12factor.net/). Set up a home lab to work with virtualization or another system. Experiment in this lab by creating, editing, and deleting Terraform resources to gain confidence in your code.

After all, Terraform is not such a huge rocket science. These efforts will undoubtedly pay off in the long run.

</div>
