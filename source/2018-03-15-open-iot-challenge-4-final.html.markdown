---
title: Open IoT Challenge 4.0 final report 
date: 2018-03-15 10:41 UTC
tags: open_iot_challenge, cloud_oscilloscope
---

![1](https://dronov.net/images/osc/1.png)

### Hello! 

Welcome to our journey to Open IoT Challenge by Eclipse! Last December our proposal was chosen 
from 70 proposal to participate. Also we've got a promocode for electronics and started to work.

Our project is Cloud Osciloscope. [Here](https://dronov.net/2017/11/17/we-make-an-open-source-cloud-oscilloscope.html) you can read a full history. 

![2](https://dronov.net/images/osc/2.png)

Working with embedded devices we need to use oscilloscope to check what's going wrong in corrupted device. We don't exactly know the actual reason 
of wrong work of device. Oscilloscope can help us to recognize the problem and see the packet sended for example from cpu, uart of other interface.

It is okay when your team located in one place. But when you have a remote team, you can't easily show your oscillograms to other members. 
Yes, you can make a video and upload it to YouTube, but doing it every time is very embarassing (checked by us). 

That's why we decided to build not only the o-scope.  

![1](https://dronov.net/images/osc/3.png)

We think that cloud o-scope could be useful for DIY. Many professional o-scopes have a big cost and better equipment. But for usual application
no need to use very accurate components. 

Low cost and build instructions can help students to get a working oscilloscope in their personal labs. Our prototype costs about 60$ like Raspberry Pi, so we think
it is a good opportunity to get an oscilloscope like in University/College. 

Also we think about application at radio industry between engineers. In Russia radio is very popular. Many people like to build radio receiver by hands and speak with them.
Making o-scope with battery can help to bring it on the road and check any device.  

![1](https://dronov.net/images/osc/4.png)

We tried to use cheap components as possible. That's why we've chosen an Orange Pi Zero as a main supported board. You can easily get it from Aliexpress, 
and many of onboard features supported in Armbian Linux. 

We wrote a [qt-application](https://gitlab.com/cloud-oscilloscope/qtloscope) that should be run on oscilloscope.

Here it is a probable PCB of ADC-shield connected with Orange Pi Zero (not fully tested). You can find all components and build scheme [here](https://dronov.net/2018/03/13/build-scheme.html).

![pcb](https://dronov.net/images/osc/oscill.jpg)

![1](https://dronov.net/images/osc/5.png)
![1](https://dronov.net/images/osc/6.png)

Imagine that you have two Arduino Pro micro with equal firmware: one is working, second not. You want to discover what's going on corrupted device and decide to use cloud oscilloscope. 

![first](https://media.giphy.com/media/1dLjRzvGVvfOcqjPbo/giphy.gif)

First of all turn on your oscilloscope. You should see the empty graph if you already have build o-scope and installed software.

![turn off](https://media.giphy.com/media/lJLRG19Fb4YDYAQBNL/giphy.gif) 

At this example we work with SoftwareSerial at Arduino that sends data. We need to connect o-scope's probe and SoftwareSerial pin. Here it a beginning of oscillogram:

![get data correct](https://media.giphy.com/media/mByxRfYvvG1CCAf8Zh/giphy.gif)

After that we need to press data button to save an oscillogram, connect to MQTT. Next press will upload saved oscillogram to cloud.

![upload](https://media.giphy.com/media/IkliV04dN44qwuGDsP/giphy.gif)

This is how uploaded oscillogram is showing in the web-interface. Click [here](http://oscilloscope.cloud/pastes/k59nzgiqejzcibz555w4aw) to view paste.

![](http://joxi.ru/12MjVZDfMjKnzA.png)

Let's make similar actions with corrupted Arduino: 

- Connect probe
- Write data
- Send data

![corrupted data](https://media.giphy.com/media/nEMIMhWm76FdG8ZSBr/giphy.gif)

This is screenshot with oscillogram from corrupted Arduino. Click [here](http://oscilloscope.cloud/pastes/mvqpgvirqentue-mgmokzq) again.

![oscillogram](http://dl4.joxi.net/drive/2018/03/15/0010/1401/693625/25/b93073164b.png)

At the ["My diffs"](http://oscilloscope.cloud/raw_diffs) section you can choose these oscillograms and make a graph like a diff, check out where things went bad.

![diff](http://joxi.ru/V2VKGdBfx3a0oA.png)


Yeah! It works! Now you can share oscillograms with remote colleagues.  

![good job](https://i.imgflip.com/26fugw.gif)

![1](https://dronov.net/images/osc/7.png)

This Open IoT Challenge was a great motivation for us. We built one working prototype of our service. It is ready to use by us, but we need 
to make a new refactoring of PCB, code. 

We're working on Cloud Oscilloscope in our free time doesn't connected with our work. So we don't have a lot of free time. That means 
that time of making new features will be amazingly unpredictable. More of that, with little community of five persons you can't truly say does 
your feature need to others. 

So, the first lesson is to concentrate on solving real problems. You can make a feature very fast, get positive feedback and make refactoring 
later. In our case it works, we have some feature that not realized in this challenge. Some of features looks strange after some months, for example. 

Second lesson, you should build a community near your project as soon as possible. This community may consist from nearest people, but you 
have to show them results of your work to get a feedback. More feedback, more knowledge about your project, more useful changes.  

Third lesson, throw away your fear and just do your work. Some of features we made without solid knowledge of usefulness. For example,
when Andrey had started to design a schematics of PCB he hadn't know exactly the result and tried to make most simple solution. And it works! 

Don't give up and get things done!

![1](https://dronov.net/images/osc/8.png)

Thank you that you were with us all this time! But the real adventure has started recently. We don't want to stop work on Cloud Oscilloscope. We hope to build a great community of engineers, programmers, radio-fans and other people.

And, of course, thank you Roxanne and Benjamin! You are amazing! 

Stay in touch! 

[http://oscilloscope.cloud/](http://oscilloscope.cloud)