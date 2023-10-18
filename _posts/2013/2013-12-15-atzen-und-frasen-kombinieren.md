---
author: lespocky
layout: post
title: "Ätzen und Fräsen kombinieren"
date: "2013-12-15"
categories: 
  - "laufende-projekte"
tags: 
  - "cnc-frase"
  - "dxf"
  - "eagle"
  - "eps"
  - "inkscape"
---

Wir können selbst Platinen ätzen und wir haben eine CNC-Fräse. Letztere zum Ausschneiden und Bohren der selbst geätzten Platinen zu benutzen, liegt nahe. Im Detail ist das leider nicht so einfach wie man denkt. Man besehe sich dieses Bild:

| ![](/assets/img/post-img/2013/eagle-eps-inkscape-dxf-fräse.jpg) |
|:--:|
| geätztes gefräst |

Auffällig ist dass das kreisrund geätzte Logo nicht kreisrund ausgefräst wurde. Doch wie kam das? Um das zu verstehen, hier ein kurzer Überblick über die Prozesskette:

Verschiedene Layouts in Eagle designet. Die Platinen haben alle unterschiedliche Größen zwischen 15×25mm² und 78×78mm² und damit man nicht alles fünf mal macht, will man mehrere Schaltungen auf einer (oder einer halben) Euro-Platine (100×160mm²) ätzen und dann fräsen – speziell weil wir einen Rahmen haben, um genau diese Größe auf der Fräse einzuspannen und auszurichten. Dummerweise bietet Eagle für so eine Aktion keinerlei Unterstützung, auch der professionelle Eagle-Coach auf der OHM2013 sagte, das müsse man dann extern nachbearbeiten.

Der erste Ansatz war nun in Eagle die Boards im CAM-Prozessor als .eps zu ex- und in Inkscape zu importieren. Dort lässt sich das alles fluffig ausrichten und ohne Skalierungsprobleme ausdrucken zum Ätzen. Soweit so gut, für die Fräse brauchen wir aber .dxf um daraus die Fräspfade und damit den G-Code zu generieren. Wenn man in Inkscape .dxf exportiert und dann nochmal mit Draftsight in einem anderen .dxf-Format speichert, dann kann man endlich im … naja und dann kommt das da oben raus. :-/

Eagle selbst kann .dxf exportieren, auch mit allen Layern. Damit kann Inkscape nichts anfangen (stürzt beim Import ab). Das .dxf ist ideal für die Fräse, aber die üblichen Programme um .dxf zu bearbeiten, vulgo CAD-Programme, machen es einem nicht leicht, daraus eine brauchbare Ätzvorlage zu erzeugen bzw. auszudrucken.

Wer da einen brauchbaren Workflow hat oder ein funktionierendes Setup, bitte melden! ;-)
