---
layout: post
title: "Zwei DIY-Uhren: Eine Reise von der Idee zur fertigen Nixie- und VFD-Uhr"
date: "2025-12-26"
tags:
  - "diy"
  - "löten"
  - "platine"
  - "firmware"
thumbnail: "/assets/img/post-img/2025/nixie-vfd/thumbnail.jpg"
feature-img: "/assets/img/post-img/2025/nixie-vfd/feature-image.jpg"
author: max2
---

DIY-Uhren gehören zu den Projekten, die ziemlich gut die Mischung aus Platinendesign, Firmware-Coding und etwas Handwerk aufzeigen. In diesem Beitrag möchte ich euch zwei solche Uhren vorstellen, die ich gebaut habe.

Entstanden ist eine **Nixie-Uhr** mit ihren typischen leuchtenden Ziffern in Neonröhren – und eine **VFD-Uhr**, deren Ziffern mit einem türkisfarbenen Glimmen an alte Geräte aus den 90er erinnert.

Beide Uhren entstanden von Grund auf: Von der Schaltplanentwicklung über die Platinenfertigung und Bestückung bis hin zur Firmware für den **STM32F1**-Mikrocontroller und dem **Gehäuse** aus Eschenholz.

## 1. Die Idee: Warum zwei Uhren?

Nixie- und VFD-Röhren zählen für mich zu den schönsten Anzeigeformen der Elektronikgeschichte. Während Nixies mit ihrem warmen, orangefarbenen Licht nostalgisch und steampunkig wirken, geben die VFDs ein futuristisch anmutendes, kaltes Glühen ab.

Beides wollte ich ausprobieren – und beide Technologien erfordern eine andere Herangehensweise an die Elektronik.

![](/assets/img/post-img/2025/nixie-vfd/thumbnail.jpg)

---

## 2. Planung
Erstmal habe ich auf Ebay Röhren bestellt, welche noch nie in Betrieb waren und damit Neuware sind. Die damalige Sowjetunion hat die Röhren in Massen hergestellt, sodass man noch gut an Neuware ran kommt, obwohl die Nixie-Röhren bereits in den **70er-Jahren** und die VFD-Röhren in den **90er-Jahren** hergestellt wurden!
Mit diesen Röhren habe ich dann mithilfe eines Labornetzteils erste Tests durchgeführt, um zu schauen, welche Spannungen erforderlich sind und wie man sie generell ansteuert. Als ich die Infos dann zusammen hatte, ging es gleich zum Schaltplan-Design.

![Nixie-Röhren](/assets/img/post-img/2025/nixie-vfd/nixie-roehren.jpg)

## 3. Schaltpläne

Beide Uhren brauchen verschiedene Schaltpläne und dementsprechend unterschiedliche Platinendesigns, da die Röhren selbst unterschiedliche Ansteuerungen und Versorgungsspannungen benötigen. Dennoch teilen sich beide den gleichen Mikrocontroller **STMF103**, damit für beide Platinen die gleiche Firmware verwendet werden kann und somit doppelt vorhandene Codeblöcke einsparen kann. Die Firmware erkennt dann, auf welcher Uhr sie läuft und nimmt dementsprechend im Firmwarecode geringfügig andere Wege.

### Schaltplanentwurf

Der Schaltplan wurde in [KiCad](https://www.kicad.org/) entworfen. Für beide Uhren musste die Eingangsspannung (24 Volt DC) auf die passende Versorungsspannung mithilfe eines Boost-Converters hoch konvertiert werden.
**Nixie-Röhren** benötigen typischerweise **170 Volt DC**, allerdings beträgt die Stromaufnahme pro Ziffer nur wenige Milliampere.
**VFD-Röhren** brauchen dagegen nicht so hohe Spannungen (20–30 Volt DC) für die Segmente. Das macht die Schaltung weniger gefährlich.

![Schaltplan der Nixie-Uhr](/assets/img/post-img/2025/nixie-vfd/circuit-on-computer.jpg)

Die Schaltpläne sind jeweils auf **GitHub** öffentlich einsehbar. Links sind am Ende des Artikels aufgelistet.

---

## 4. Platinenlayout

Wenn ein Schaltplan fertig ist, können im nächsten Schritt die Platinen gelayoutet werden. D. h., die Elektronikkomponenten, welche später gelötet werden, bekommen ihren Platz auf der Platine und die Leiterbahnen werden gezogen. Anschließend wurden diese beim Platinenhersteller des Vertrauens bestellt.

![PCB-Plainen](/assets/img/post-img/2025/nixie-vfd/blank-pcbs.jpg)

> **Technik-Detail**
> Beim Layouten von Hochspannungskomponenten sollten einige Millimeter **Kriechstrecke** zwischen Leiterbahnen mit großen Spannungsunterschieden eingehalten werden.

---

## 5. Bestückung & erste Tests

Die Bauteile wurden anschließend per Hand bestückt – von Widerständen bis zu den Treiber-ICs.

Bevor die eigentlichen Röhren auf die Platine gelötet werden, wurden die grundlegenden Funktionen getestet wie  z. B. das korrekte Anliegen/Arbeiten der Versorungsspannungen und des Mikrocontrollers.
Erst danach kam die erste Röhre und ich konnte es kaum erwarten, sie in Aktion zu sehen. Siehe da, sie hat gleich funktioniert! 😍

![Erste Nixie-Röhre](/assets/img/post-img/2025/nixie-vfd/nixie-test.jpg) | ![Erste VFD-Röhre](/assets/img/post-img/2025/nixie-vfd/vfd-test.jpg)

> **Technik-Detail**
> Für die erste Inbetriebnahme empfiehlt sich ein regelbares Labornetzteil mit Strombegrenzung. So lässt sich verhindern, dass ein Fehler im Design direkt Bauteile zerstört.

---

## 6. Firmware: Steuerung für Anzeige der Zeit

Die Firmware für den STM32F1 wurde in C++ geschrieben. Wichtige Funktionen:

- Zeit abholen über serielle Schnittstelle von einem ESP32 (WLAN-Mikrocontroller)
- Multiplexing der Anzeigesegmente inkl. Dimmbarkeit
- Übergänge zwischen Ziffern animieren (Fading), um alte, nachlaufende Elektronik zu simulieren

> **Technik-Detail**
> Multiplexing erfordert exakte Timingsteuerung. Der Ansatz hier ist das Setzen eines **Timer-Interrupts** alle 250 µs, um sichtbares Flimmern zu vermeiden. In dem Interrupt wird die nächste Ziffer aktiviert und die vorherige ausgeschaltet.

---

## 7. Das Holzgehäuse

Für beide Uhren sollte das Gehäuse schlicht, aber elegant wirken – daher fiel die Wahl auf massives Eschenholz. Das Holz wurde zugeschnitten und mit CNC-Fräse bearbeitet und anschließend mit Hartwachsöl versiegelt.

![Rohholz](/assets/img/post-img/2025/nixie-vfd/case.jpg) | ![Fräsvorgang](/assets/img/post-img/2025/nixie-vfd/case2.jpg)
![Gehäuse](/assets/img/post-img/2025/nixie-vfd/case3.jpg) | ![Uhr im Gehäuse](/assets/img/post-img/2025/nixie-vfd/vfd-in-case.jpg)

---

## 8. Fazit

Der Bau einer Nixie- oder VFD-Uhr war ein tolles Projekt, das Elektronikdesign, Firmwareentwicklung und Holzhandwerk miteinander verbindet. Am Ende stehen nicht nur Zeitmesser an sich, sondern auch dekorative Einzelstücke, die Retro-Technik erstrahlen lassen.

Wer sich an solch ein Projekt wagt, wird schnell feststellen: Der Weg ist mindestens so interessant wie das Ergebnis.

![Beide Uhren](/assets/img/post-img/2025/nixie-vfd/both-clocks.jpg)

![Nixie-Uhr](/assets/img/post-img/2025/nixie-vfd/nixie-show.jpg)

![VFD-Uhr](/assets/img/post-img/2025/nixie-vfd/vfd-all-on.jpg)

## 9. Links

Auf GitHub sind die Schaltpläne, Platinendesigns und die Firmware gehostet:
- [Nixie-Schaltplan](https://github.com/MG-5/nixie-clock-hardware)
- [VFD-Schaltplan](https://github.com/MG-5/vfd-clock-hardware)
- [Firmware](https://github.com/MG-5/nixie-vfd-clock-firmware)




