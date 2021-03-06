---
title: Как не облажаться на Хардатоне
date: 2017-03-13 00:22 UTC
tags: хардатон
---

![Хардатон](https://pp.userapi.com/c638522/v638522308/29db1/DUuitoBkKJY.jpg)

Это пост — ещё одно напоминание о предстоящем Хардатоне.

Хардатон — мероприятие для нашей отчизны, в целом, довольно свежее. Почему нельзя
так просто взять, приехать в другой город (как проходят многие Хакатоны) и организовать сие действие за одну неделю —
требуется довольно много оборудования. Это, к примеру, 3D-принтеры, лазерные станки, измерительное оборудование (осциллографы, мультиметры, etc), Arduino/Raspberry Pi/esp8266, паяльники/паяльные станции, и многое другое. И, да, этого оборудования должно хватать на аудиторию Хардатона (одно дело на 50 человек, другое на >150).

Цель Хардатона — прототип устройства. Это не только пописать код в своё удовольствие. Код внезапно становится не самой важной вещью в финальном прототипе. Тут уже нужно и электроникой/схемотехникой позаниматься, сделать корпус устройства,
и собрать его так, чтобы что-нибудь работало. И всё это за 48 часов.

В целом, стратегия "как не облажаться на Хардатоне" зависит от многих параметров, но есть некоторые общие выявленные черты, проявляющиеся у многих команд, независимо от того,
подозревают они это или нет.


### Понятная задача

На мой взгляд, это самый сложный фактор. 48 часов — время довольно ограниченное. В эти
часы вам будет хотеться не только работать над своим проектом, но и есть, консультироваться
с другими участниками, и, иногда, спать. Очень важно не тратить время зря. Если ваша идея
проекта описывает довольно сложное устройство — уберите ещё до начала работы 70% функциональности. А, помозговав, от оставшихся 30% уберите ещё 70%. Оставьте какую-нибудь одну важную часть проекта и сделайте её рабочей. Есть такое ̶х̶и̶п̶с̶т̶е̶р̶с̶к̶о̶е̶  понятие, как MVP — Minimal Viable Product — минимальный рабочий прототип продукта (пора отправиться гладить свои узкие джинсы и делать смуззи). Короче, лучше сделать меньше, но лучше. Простите за тавтологию.

### Домашние заготовки

Есть наработки прототипа устройства? Разведённые платы, полусобранные корпуса и полунаписанный софт? Круто, тащите всё с собой! Используйте понятные и знакомые
железки/софт/etc, иначе есть реальная возможность потратить львиную долю Хардатона на чтение чужого кода и попыткам понять, как поднять ту или иную часть железки, с которой вы работаете (что, собственно, и случилось с проектом, который пилила моя команда). С другой стороны, Хардатон должен приносить радость и удовлетворение: разобраться с какой-нибудь технологической задачей и расшарить после Хардатона этот опыт другим — тоже круто!

### Наличие команды

Все участники Хардатона делятся на две категории: те у кого есть сформированная команда, и те, у которых её нет. В первом случае будет хорошая возможность что-нибудь распараллелить (например, работу с софтом и проектирование корпуса). Это обязательно нужно использовать, так как не времени будет всегда не хватать.

Во втором случае придётся посложнее. Даже если вы один и не имеете навыков проектирования корпуса или работы с определённой электроникой — это не беда. Обычно на Хардатоне есть определённое количество личностей, которых можно и нужно тыкать по всем возникающим вопросам (на прошлом Хардатоне мы не нашли характеризующего слова для таких людей, кроме как "Эксперт"). Как показывает практика, при правильном подходе к решению возникающих проблем, результат (рабочий прототип на демо проектов) налицо.

Кроме того, нужно быть готовым к тому, что к вам никто не присоединится. Может сложиться, что большинство из участников так или иначе уже самостоятельно (до Хардатона) разделится на команды. И не всегда количество "свободных" участников может быть достаточным для укомплектации вашей команды. Но участники (и организаторы) стараются свести такие случаи к минимуму.

### Презентация

Да-да. Зачем? Есть два ̶с̶т̶у̶л̶а̶  варианта:

* Рекрутировать с помощью классной презентации ребят к себе в команду
* Если вы дожили до демо, но прототип ̶о̶т̶с̶у̶т̶с̶т̶в̶у̶е̶т̶  работает не так как надо, классная презентация может оставить всё же более-менее положительное впечатление  

### Безопасность

![оп-па](https://pp.vk.me/c604427/v604427308/475d6/IZT25QZxkfM.jpg)

Если вы себя чувствуете неуверенно перед тем как что-то запаять/перепрошить/собрать — сделайте это вместе с экспертом. Убить ардуинку или другую микросхему при определённых ̶н̶е̶ ̶о̶ч̶е̶н̶ь̶ ̶х̶о̶р̶о̶ш̶и̶х̶ обстоятельствах не составляет никакого труда.

В целом, по рекомендациям всё. И теперь немного лирики.

### Тренды прошлых Хардатонов

* Arduino (не все хотят колхозить свои контроллеры на мероприятии)
* esp8266 (стильно, модно, молодёжно)
* мобильные приложения (внезапно)
* bluetooth (внезапно)
