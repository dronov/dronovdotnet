---
title: We make an open-source Cloud Oscilloscope
date: 2017-11-17 10:19 UTC
tags:
---

### Hello there!

This is a short history about our Cloud Oscilloscope or why we should be in Top 10 proposals at Open IOT Challenge.

This project started about a year ago at the Hardware Hackathon in Ulyanovsk. The first idea became before those 48
hours of fun, coding and soldering.

![Team](https://pp.userapi.com/c604427/v604427308/458c9/UVE90QHihGE.jpg)
*Part of our team a year ago. From left to right: Dmitry Chernyatev, Mikhail Dronov, Evgeniy Nenilin*

The main goal was to make a useful, interesting and cheap device with low price about 60-70$. That’s why we decided to
use the cheapest components and chose the fresh Orange Pi Zero. It was a 48 hours of hell: Orange Pi Zero just released
and arrived to us from Aliexpress, datasheet was not opened, sdk was not checked correctly. We spent a lot of time at
Hardware Hackathon adapted a SPI screen from Raspberry Pi to Orange Pi Zero.
We had no success at this time: screen was not setup correctly by us. Also, the planning to make a lot of things in 48
hours is not a good strategy for big long-term living projects at Hackathons. After this event we decided to make our
device step by step.

First of all we made working SPI screen in our free time. We have a right idea to use an fbtft driver, and after a long
time we make a working configuration. About a half year we have use Allwinner H2 Linux SDK from Xunlong based on H3. But
recently now we discovered a good system called Raspbian with stable Linux for Orange Pi Zero, Raspberry Pi and other
single-board computers. We make an open source hardware projects, you should be free in choice of components! I’m sure
that the one Linux distro for most platforms can help us to make a similar software and whole firmware for big variety
of platforms.

Some months ago we recognized a real pattern to use Cloud Oscilloscope. We have a task to debug a broken device and
compare it to working device. After that we should show the results to our colleagues in other city. We had to make an
oscillogram from broken device, saw at and compare with working device. We had to do it by hand. Our oscilloscope can
show the data only in real time and only on the small screen. In most cases it is enough. But not when you need to show
a complete oscillograms to others…

And... That’s it! Why we could not make a solution to grab oscillograms from device, send it to the cloud and analyze
after measurements? I don’t know! After that we realized a real motivation to complete our long-term project and share
it with others. We sure that other people have similar project. Open source is the best way to share our solution
without any copyrights problems and grab a feedback from users to make device better.

Also the Cloud Oscilloscope could be useful to make an experiments in developing electronics: sometimes it needs to make
a long measurements from the developing device, make triggers on voltage level and alert engineers that something
happened.

### What we have under the hood?

We built a device with Orange Pi Zero and ADC. It already includes WiFi to connect via MQTT with server. We’re using a
cheap SPI screen from Raspberry Pi and print oscillogram in realtime using framebuffer directly without X server. We
will add an opportunity to setup WiFi and other settings later. Right now it looks like:

![1st photo](http://dronov.net/images/IMG_0063.JPG)
*Yeah, it is the wood case and it live with us from the Hardware Hackathon :)*


![1st photo](http://dronov.net/images/IMG_0064.JPG)
*Our working prototype of Cloud Oscilloscope shows his entrails*

### What’s next?

We need to make a stable device. This is an approximate task list for next 2 months:

- Right now we have some problems with measurements from the cheap MCP3201 ADC to show the correct oscillograms. It could
be solved by a little count experiments, maybe we will change ADC
- Change the antenna from Orange Pi Zero because default antenna is terrible
- Complete a prototype of final software for oscilloscope. Based on qt, we need to add some features like connecting to
wifi, editing viewing oscillogram on the screen, enter login and password from cloud platform
- Add a hardware keyboard (maybe from the old mobile phone)
- Redesign a prototype to make device vertical, print new case, etc…
- Pack the software to Armbian (or maybe other distro, everything is changing very fast) image

After this steps we will have a time to make a little cloud. We’re planning to write a service like pastebin for
oscillograms in the future. It will be written in Golang, packed to Docker containers and deployed to Openshift ot
Docker Swarm. And yeah, Eclipse Mosquitto and Paho are the best friends for us :)

Besides of this we need to make a website for our service which allows users to register, connect the oscilloscope, make
a oscillogram diffs and share it. We need to solve usual features like authorization, management, api and other. Our
source of inspiration are Github with diffs and pastebin with code shares.

We think our device could be useful for studying, when you don’t need to buy an expensive equipment to work with. Our
cheap solution will show the results not so accurate than expensive professional equipment, but it will be enough for
studying and cheap to buy and make.

We will share all software, firmware, schematics and other parts of our Cloud Oscilloscope. Right now we have only one
opened repository based on Xunlong SDK at [Gitlab](https://gitlab.com/dronov/pizero-docker) with the first sdk we worked with. And, of course, we will make new
repositories and maybe resources to discuss and share experience!

Get cheaper, get better, get open!

Stay in touch!
