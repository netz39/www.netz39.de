---
author: lespocky
layout: post
title: "Network UPS Tools (NUT) unter Debian Wheezy mit einer MGE Ellipse 600"
date: "2013-02-27"
categories: 
  - "maschinenraum"
tags: 
  - "debian"
  - "howto"
  - "usv"
---

# Network UPS Tools (NUT) unter Debian Wheezy mit einer MGE Ellipse 600

Uninterrupted Power Supply (UPS) oder zu deutsch Unterbrechungsfreie Stromversorgung (USV) ist das, was man am Server haben will um sich gegen kurze oder längere Stromausfälle zu schützen, genauer um seine Hardware vor den Auswirkungen derselben zu schützen. Dicker Akku, bisschen Elektronik und schon läuft der Server weiter, wenn mal kurz der Strom weg ist. Zutaten für das Rezept heute: [Dell PowerEdge 1750](http://www.netz39.de/wiki/internal:inventory:computer:kant) mit installiertem [Debian](http://www.debian.org/) 7.0 aka Wheezy und eine gespendete [MGE Ellipse 600](http://powerquality.eaton.de/Products-services/Backup-Power-UPS/Ellipse-MAX.aspx). Als Software werden wir NUT installieren, das ist laut Internet wohl Weapon of Choice.

Warum noch ein HowTo: nun ja, neue Version des Betriebssystems, Doku passt nicht, bisschen Rumbasteln nötig, Ihr kennt das.

## Hardware anschließen

Wie man die Kabel da zusammensteckt, muss ich hier nicht erklären, jedenfalls lässt sich das Gerät per USB anschließen und meldet sich dann auf `lsusb` wie folgt:

    Bus 003 Device 004: ID 0463:ffff MGE UPS Systems UPS

## Software Installieren

Okay, Gerät bekannt, prima soweit, dann erstmal NUT installieren. Entweder das metapackage `nut` oder `nut-client` und `nut-server` einzeln, ich hab auch noch die Dokumentation installiert:

    aptitude install nut nut-doc

## udev einrichten

Zu allererst geh ich mal in die Doku, will sagen in `/usr/share/doc/nut/README.Debian.gz` geschaut und siehe:

>For USB devices, permissions are automatically set by the
>/lib/udev/rules.d/52-nut-usbups.rules udev rules file.

Aber die Datei gibt's gar nicht, dafür gibt es `/lib/udev/rules.d/52-nut-usbups.rules` und die enthält:

    \# This file is generated and installed by the Network UPS Tools package.
    ACTION!="add|change", GOTO="nut-usbups_rules_end"
    SUBSYSTEM=="usb_device", GOTO="nut-usbups_rules_real"
    SUBSYSTEM=="usb", GOTO="nut-usbups_rules_real"
    SUBSYSTEM!="usb", GOTO="nut-usbups_rules_end"
    LABEL="nut-usbups_rules_real"
    #  various models  - usbhid-ups
    ATTR{idVendor}=="0463", ATTR{idProduct}=="ffff", MODE="664", GROUP="nut"
    LABEL="nut-usbups_rules_end"

Ah da haben wir ja Vendor- und Produkt-ID und das stimmt auch mit der Ausgabe von `lsusb` überein, wird nur irgendwie von udev noch nicht automatisch geladen. :-/ Es gibt dazu diverse Bugreports (bspw. [660072](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=660072)) in Debian, alle geschlossen, obwohl es nicht auf Anhieb tut – naja sagen wir, obwohl es falsch oder unverständlich beschrieben ist. Jedenfalls dann nach `/etc/udev/rules.d` gehen und

    ln -s /lib/udev/rules.d/52-nut-usbups.rules

ausführen, udev neu starten, neu booten oder USB-Gerät ab- und wieder anstecken oder beides, was da jetzt genau geholfen hatte, weiß ich grad nicht mehr. Das war der unkomplizierte Teil. Die Konfiguration von NUT verteilt sich dann nämlich auf mehrere Dateien, weil man mit der Software auch abgefahrene Konfigurationen mit mehreren USV und Rechnern aufbauen kann, bunte Bildchen [hier](http://www.networkupstools.org/docs/user-manual.chunked/ar01s03.html).

## Treiber konfigurieren

Bevor wir irgendwas anderes machen, einmal in die Datei `/etc/nut/nut.conf` gehen und die Zeile mit `MODE` suchen und anpassen, sonst startet der `upsd` später erst gar nicht. Hier sieht das so aus:

    MODE=standalone

In `/etc/nut/ups.conf` konfigurieren wir dann den Treiber bzw. machen der Software bekannt, was wir für eine USV angeschlossen haben, indem wir einen Abschnitt hinzufügen:

    [MGE_something]
          driver = usbhid-ups
          port = auto

Ganz einfach, wenn man den USB-Teil mit udev vorher klar hat. Theoretisch kann man da auch noch mehr Optionen angeben, wenn man nicht mehrere USV am Server hat, kann man sich das aber klemmen.

## Kurztest

Zeit unser Gerät zu testen und zwar mit

    upsc MGE_something@localhost | less

was dann ungefähr folgendes ausgibt:

      battery.charge: 92
      battery.charge.low: 30
      battery.runtime: 1408
      battery.type: PbAc
      device.mfr: MGE OPS SYSTEMS
      device.model: Ellipse 600
      device.serial: BDBJ32016
      device.type: ups
      driver.name: usbhid-ups
      driver.parameter.pollfreq: 30
      driver.parameter.pollinterval: 2
      driver.parameter.port: auto
      driver.version: 2.6.4
      driver.version.data: MGE HID 1.31
      driver.version.internal: 0.37
      input.transfer.high: 264
      input.transfer.low: 184
      outlet.1.desc: PowerShare Outlet 1 
      outlet.1.id: 2
      outlet.1.status: on
      outlet.1.switchable: no
      outlet.desc: Main Outlet
      outlet.id: 1
      outlet.switchable: no
      output.frequency.nominal: 50
      output.voltage: 230.0
      output.voltage.nominal: 230
      ups.beeper.status: enabled
      ups.delay.shutdown: 20
      ups.delay.start: 30
      ups.load: 20
      ups.mfr: MGE OPS SYSTEMS
      ups.model: Ellipse 600
      ups.powups.productid: ffff
      ups.serial: BDBJ32016
      ups.status: OL CHRG
      ups.timer.shutdown: -1
      ups.timer.start: -10
      ups.vendorid: 0463

## Weitere Einrichtung

Gleich geschafft, nur noch zwei Dateien editieren. Erstmal `/etc/nut/upsd.users`

    [admin]
          password = 12345
          actions = set
          actions = fsd
          instcmds = all

    [monmaster]
          password = 12345
          upsmon master

    [monslave]
          password = 12345
          upsmon slave

Die Erklärungen dafür kann man ausführlich in der Doku nachlesen. In kurz: wir haben verschiedene Nutzer, die verschiedene Dinge dürfen mit der USV und setzen da Berechtigungen und Passwörter (Sichere Passwörter siehe [YouTube](https://www.youtube.com/watch?v=_JNGI1dI-e8)) und daher. Ja und zu guter letzt, warum wir den ganzen Kram hier eigentlich machen, wird dann in `/etc/nut/upsmon.conf` aktiviert, nämlich dass der Server auch sauber runterfährt, wenn der Strom zu lang weg bleibt. Da gibt's viele Erklärungen in der Datei, die defaults erschienen mir sinnvoll, so dass ich an passender Stelle nur eine Zeile hinzugefügt habe:

    MONITOR MGE_something@localhost 1 monmaster 12345 master

Damit läuft das erstmal so, dass der Rechner automatisch runterfährt nach ungefähr 10 Minuten. Weitere Überwachung mit munin oder nagios oder oder oder ist dann advanced topic. Für einfach nur mal eben schnell USV zum Laufen kriegen ist das HowTo hier ja auch lang genug. ;-)
