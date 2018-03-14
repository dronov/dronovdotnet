---
title:  Cloud Oscilloscope backend architecture
date: 2018-03-06 11:39 UTC
tags: open_iot_challenge, cloud_oscilloscope
---

Hello! 

We're working on a backend for our Cloud Oscilloscope project. On the last meetings we decided 
to use common technologies for IoT to connect our device with backend. 

![architecture](http://dronov.net/images/arch.png)

#### MQTT

It is a heart of our service.   MQTT is well described and easy to use protocol. Many frameworks have a library to use MQTT. Besides of this we have an expirience to use MQTT with esp8266, mosquitto server, golang and javascript clients.  

For the Open IoT Challenge we will use an [Eclipse sandbox](iot.eclipse.org:1883)

#### PostgreSQL 

We need a database to store data from oscilloscopes by some rules. We don't need only store data. We  need to make a diff from oscilloscopes at different types. Usually we work with PostgreSQL in web projects. 

#### Microservice

It subscribes to the device topic, gets data from oscilloscope via MQTT and saves in PostgreSQL. Nothing else. Written in Golang. 

#### Web-interface

We use Rails framework for making web-services. It will be a standalone website with common (like authentication, user management) and custom features. The main goal of this service is make oscilloscope's diffs from different times. We want to make diffs like at [Github](https://github.com/), where we can show 
someone that device is really broken or working. It useful when you work with embedded device and try to figure out what is really wrong when your device broken or works incorrectly. You can just make oscillogram from both devices and compare them into diff. And, of course, make a paste with diff like pastebin.com and share it with colleague/friend. :) 

Don't forget that [Open IoT Challenge](https://iot.eclipse.org/open-iot-challenge/) ends at 15 March! 
Cya