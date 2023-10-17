---
layout: post
title: "ATtiny85 with 16MHz"
date: "2014-01-03"
categories: 
  - "laufende-projekte"
tags: 
  - "avr"
---

Für unser »Starterkit« habe ich in den letzten Tagen ein wenig mit der PWM experimentiert um zu sehen, was sich da qualitativ rausholen lässt. Eine 10-Bit-Soft-PWM mit dem bisherigen Ansatz flackert bei 8 MHz CPU-Takt, der sich ohne die Fuse-Bits des AVR anzufassen leicht einrichten lässt, indem man über das Register CLKPS den Prescaler anpasst. Sie System Clock des ATtiny läuft dann praktisch direkt mit den 8 MHz des internen Oscillators.

Der AVR kann noch mit anderen Taktraten laufen, laut Datenblatt mit bis zu 20 MHz. Da wir bei der Schaltung jedoch keine Pins für externen Takt mehr frei haben, muss der interne Takt herhalten und da geht auch noch was. Schaut man sich Figure 6.2 im kompletten Datenblatt an, fällt die PLL ins Auge und da kann man ansetzen. Mit den richtig gesetzten Fuses für CKSEL kann man direkt 16 MHz einstellen. Das Anpassen des Prescalers ist aber dennoch nötig.

Laut Datenblatt will man CKSEL zu 0001 haben statt der 0010, die default eingestellt sind und den internen RC-Oscillator auswählen. Mit Hilfe des [Fuse Calculator](http://www.engbedded.com/fusecalc) bekommt man raus, dass die low fuse von default `0x62` auf `0x61` gesetzt werden muss, wenn man vom default ausgeht und nur CKSEL ändern will. Mit avrdude geht das so:

avrdude -p t85 -P usb -c usbtiny -U lfuse:w:0x61:m

Damit läuft das Ding mit 16 MHz und eine grobe Überschlagsrechnung zeigt, dass die LED dann eine »Framerate« von etwas über 30 Hz hat und das sieht flackerfrei aus und schön smooth … :-)

Zurücksetzen auf default wäre dann übrigens so:

avrdude -p t85 -P usb -c usbtiny -U lfuse:w:0x62:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

Da werden dann auch die anderen beiden Fuses gesetzt.
