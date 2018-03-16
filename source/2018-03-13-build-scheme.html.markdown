---
title: Build Cloud Oscilloscope!
date: 2018-03-13 14:04 UTC
tags: open_iot_challenge, cloud_oscilloscope
---

Hello!

 You need a number of components to assemble Cloud Oscilloscope. Most of them can be bought at the nearest radio store or on AliExpress. 

The main components of Cloud Oscilloscope are a singleboard computer, spi-display and custom ADC-shield. Now we are working with Orange Pi Zero, but in the future we will port software to Raspberry Pi and any other singlebard computer. 

If you have 3D-printer you can print a case for oscilloscope. Check links at the main components list.

Main components:

* [Orange Pi Zero](https://ru.aliexpress.com/item/Orange-Pi-Zero-H2-Quad-Core-Open-source-256MB-development-board-beyond-Raspberry-Pi/32760774493.html?spm=a2g0s.9042311.0.0.CrCaTH)
* [SPI-display](https://ru.aliexpress.com/item/3-2-Inch-TFT-LCD-Display-Module-Touch-Screen-For-Raspberry-Pi-B-B-A/32628482115.html?ws_ab_test=searchweb0_0,searchweb201602_4_10152_5711320_10151_10065_10344_10068_10342_10343_10340_10341_10543_10084_10083_10618_10307_10301_5711220_5722420_10313_10059_10534_100031_10103_10627_10626_10624_10623_10622_10621_10620_10125,searchweb201603_25,ppcSwitch_5&algo_expid=828ec22e-b776-4c51-a199-00045f8d2efb-0&algo_pvid=828ec22e-b776-4c51-a199-00045f8d2efb&priceBeautifyAB=0)
* 3D-printed case ([front part](https://www.thingiverse.com/thing:2824447), [back part](https://www.thingiverse.com/thing:2824450))

![front_case](https://cdn.thingiverse.com/renders/47/68/ba/2a/ce/ced77617d724da10e00afbfd91e3a640_preview_featured.jpg)
![back_case](https://cdn.thingiverse.com/renders/07/c2/32/0a/93/e18ec2c93dc39543b30bcb98139ae95d_preview_featured.jpg)


Use this scheme to build ADC-shield: 
[<img src="http://dronov.net/images/oscilloscope.jpg">](http://dronov.net/images/oscilloscope.jpg)

Components for ADC-shield:

* U1-mcp3201, dip-8
* P1 - BNC connector
* P2, P3 - TRG5-5VDC relay
* P4, P5-connector 2.54 mm pitch 13*2 pins
* P6, P7-connector 2.54 mm pitch 5 pins
* P8 - connector 2.54 mm pitch 3 pins
* Q1, Q2 - NPN 2n5551 — 2
* R1, R8-4.7 k, 0.25 W
* R2-5M, 0.25 W
* R3-4M, 0.25 W
* R4-1M, 0.25 W
* R5, R7-820, 0.25 W
* R6-100, 0.25 W
* D1-zener diode 2,4 v
* D2, D3-zener diode 4.7 v
* C1, C4 - 47µF
* C2, C3 - 0.1 µF
* ec11 encoder for arduino x2

If the output of the button on the Board is not pulled up (pull up) resistor, you need to add a 10 kOm resistor: 

![encoder patch](http://dronov.net/images/encoder-patch.jpg)

This is a first prototype of Cloud Oscilloscope so it contains a little count of bugs :) Don't afraid of this, we all are working to make a stable device. 

### Update

development version of ADC-shield PCB

![pcb](http://dronov.net/images/osc/oscill.jpg)