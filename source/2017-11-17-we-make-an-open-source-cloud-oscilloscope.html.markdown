---
title: We make an open-source Cloud Oscilloscope
date: 2017-11-17 10:19 UTC
tags: open_iot_challenge, cloud_oscilloscope
---

### Hello there!

This is a short story about our Cloud Oscilloscope or why should we be in Top 10 proposals at Open IOT Challenge. The first idea emerged before those 48
hours of fun, coding and soldering.

![Team](https://pp.userapi.com/c604427/v604427308/458c9/UVE90QHihGE.jpg)
*Part of our team a year ago. From left to right: Dmitry Chernyatev, Mikhail Dronov, Evgeniy Nenilin*

The main goal was to make useful, interesting and cheap device at a price of 60-70$. That’s why we decided to use the cheapest components and chose the fresh Orange Pi Zero. It was 48 hours of hell: Orange Pi Zero has just released and delivered by Aliexpress, we didn't manage to neither open the datasheet, nor check sdk properly. We spent a lot of time at Hardware Hackathon adapting a SPI screen from Raspberry Pi to Orange Pi Zero.
We tried to configure screen, without success. Also, the plan to "make a lot of things in 48 hours" is not a good strategy for big long-term living projects at Hackathons. After this event we decided to remake our device step by step.

First of all we made working SPI screen in our free time. It was a right idea to use an fbtft driver, and after a long time we made a working configuration. About half of a year we have used Allwinner H2 Linux SDK from Xunlong based on H3. But recently we discovered a good system called Raspbian with stable Linux for Orange Pi Zero, Raspberry Pi and other single-board computers. When making an open source hardware projects, you should be free in choice of components! I’m sure that the one Linux distro for most platforms can help us to make a similar software and whole firmware for big variety of platforms.

A couple of months ago we recognized a real pattern to use Cloud Oscilloscope. The task was to debug a broken device and compare it to working one. After that we would show the results to our colleagues in other city. We had to make an oscillogram from broken device, look at it and compare with one made from working device. We had to do it by hand. Our oscilloscope can show data in real time and on small screen only. In most cases it is enough, but not when you need to show full oscillogram to others…

And... That’s it! Why couldn't we make a solution to grab oscillograms from device, send it to the cloud and analyze after that? I don’t know! After that we realized a real motivation to complete our long-term project and shared it with others. We are sure that other people have similar projects. Open source is the best way to share our solution without any copyrights problems and grab feedbacks from users to make device better.

Also the Cloud Oscilloscope could be useful to make an experiments in development of electronics: sometimes one needs to make long measurements from the device he develops, make triggers on voltage level and alert engineers that something has happened.

### What we have under the hood?

We built a device with Orange Pi Zero and ADC. It already includes WiFi to connect via MQTT with server. We’re using a cheap SPI screen from Raspberry Pi and are able to print oscillogram in realtime using framebuffer directly without X server. We will add an opportunity to setup WiFi and other settings later. Right now it looks like:

![1st photo](https://dronov.net/images/IMG_0063.JPG)
*Yeah, it is the wood case and it lived with us from the Hardware Hackathon :)*


![1st photo](https://dronov.net/images/IMG_0064.JPG)
*Our working prototype of Cloud Oscilloscope shows his entrails*

### What’s next?

We need to make a stable device.  We've got this approximated task list for next 2 months:

- Right now we have some problems with measurements from the cheap MCP3201 ADC to show the correct oscillograms. It could
be solved by small count experiments, maybe we will change ADC
- Change the antenna from Orange Pi Zero because default antenna is terrible
- Prototype a final version of software for oscilloscope. Based on qt, we need to add some features like connecting to
wifi, editing viewing oscillogram on the screen, enter login and password from cloud platform
- Add a hardware keyboard (maybe from the old mobile phone)
- Redesign a prototype to make device vertical, print new case, etc…
- Pack the software to Armbian (or maybe other distro, everything is changing very fast) image

After these steps we will have a time to make a little cloud. We’re planning to write a service like pastebin for
oscillograms in the future. It will be written in Golang, packed to Docker containers and deployed to Openshift ot
Docker Swarm. And yeah, Eclipse Mosquitto and Paho are the best friends for us :)

Besides that we need to make a website for our service which will allow users to register, connect the oscilloscope, make an oscillogram diffs and share them. Its also required to have features like authorization, management, api and other. Our source of inspiration is Github with diffs and pastebin with code shares.

We think that our device could be useful for studying, when its not required to buy an expensive equipment to work with. Our cheap solution will show the results maybe not so accurate that expensive professional equipment would produce, but they will be good enough for studying and device will be cheap to buy and make.

We will share all software, firmware, schematics and other parts of our Cloud Oscilloscope. Right now we have only one
opened repository based on Xunlong SDK at [Gitlab](https://gitlab.com/dronov/pizero-docker) with the first sdk we worked with. And, of course, we will make new
repositories and maybe resources to discuss and share experience!

Get cheaper, get better, get open!

Stay in touch!
