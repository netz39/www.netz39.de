---
layout: post
title: "Sonoff Safety Considerations"
date: "2017-02-11"
---

\[18:24:17\] [toby@jabber.n39.eu](mailto:toby@jabber.n39.eu) Sonoff Schaltplan: https://www.itead.cc/wiki/images/f/f8/Sonoff-Schmatic.pdf meine Fotos für dich: https://www.terramultimedia.de/de/smarthome/esp8266/commercial/sonoff Sonoff TH10/TH16 Schaltplan: https://www.itead.cc/wiki/images/3/39/Sonoff\_TH10A%2816A%29\_schmatic.pdf

http://tech.scargill.net/sonoff-th10-and-th16/ (Bilder dürfen mit Verweis auf das Blog verwendet werden)

\[31.01.2017 18:24:17\] [toby@jabber.n39.eu](mailto:toby@jabber.n39.eu) Sonoff Schaltplan: https://www.itead.cc/wiki/images/f/f8/Sonoff-Schmatic.pdf meine Fotos für dich: https://www.terramultimedia.de/de/smarthome/esp8266/commercial/sonoff

Sonoff TH10/TH16 Schaltplan: https://www.itead.cc/wiki/images/3/39/Sonoff\_TH10A%2816A%29\_schmatic.pdf

\[31.01.2017 21:27:34\] https://www.mikrocontroller.net/articles/Leiterbahnabst%C3%A4nde \[31.01.2017 21:28:18\] da stehen sehr viele Norman, wenn man sich ein wenig durchwühlt, findet man als Mindestabstand zwischen Netzspannung un Scutzkleinspannung Werte zwischen 1,5 und 5mm \[31.01.2017 21:29:17\] Wir befinden uns mindestens in Schutzklasse II, weil es keinen Schutzleiter gibt \[31.01.2017 21:29:44\] lt. IEC 60112 müssen wir eigentlich von IIIb ausgehen, weil wir das Material nicht kennen. \[31.01.2017 21:30:45\] die freundlicheste Norm gibt da 1mm Mindestabstand aus. \[31.01.2017 21:30:51\] Als Konsens lese ich so 3mm. \[31.01.2017 21:31:20\] Ich meine, dass wir die Rolladensteuerung auch mit 5mm zwischen Netzspannung und Schuztkleinspannung und 2mm zwischen L und N gebaut haben. \[31.01.2017 21:32:45\] Wenn ich mir das Bild angucke (Dein Link, Ansicht von unten), liegt die Netzspannung auf den Verzinnten Leitungen am oberen Rand und im Block unten rechts, der zur Mitte hin durch R16, R17, C10 und R14 begrenzt ist \[31.01.2017 21:33:33\] Kritische Abstände sind die zwischen R14/D7 und dem Pin links daneben und zwischen T17 und dem THT-Pin rechts unter D2 \[31.01.2017 21:34:16\] Ich kann an das Bild jetzt kein Lineal halten, aber wenn ich von den Bauteilgrößen ausgehe, dann wurde da gerade so der minimale Millimeter eingehalten \[31.01.2017 21:34:53\] Das heißt, das Gerät erfüllt die Schutzanforderungen wirklich nur gerade so. Für Geräte mit einem isolierenden Gehäuse ohne Schuztleiter. \[31.01.2017 21:37:15\] Was ich spannend finde: Das Gerät ist für -20°C und 95° Luftfeuchtigkeit ausgelegt. Da bildet sich Kondensat auf der Leiterplatte, das Kriechstrecken erzeugt, bei denen definitiv Strom zwischen R17 und D2 fließen kann. Das Gerät ist vielleicht für den Bereich spezifiziert, aber ich glaube nicht, dass es umfangreich getestet wurde. \[31.01.2017 21:38:00\] Was ich schade finde. Von der Idee her ist das ein richtig gutes Gerät. Aber wenn Du es verbaust, insbesondere wenn Kabel herauskommen, die jemand versehentlich berühren könnte, musst Du Dir im Klaren sein, dass das Gerät die Schutzanforderungen nur gerade so erfüllt. \[31.01.2017 21:38:51\] Für eine gute Erfüllung hätte ich 3-5mm Rand zwischen Netzspannungs- und Schutzkleinspannungsteil erwartet.

\[31.01.2017 21:44:22\] Was ich machen würde: Betrieb mit Deckel ohne weitere Kabel ja, aber ich würde keine Kabel herausführen.

\[31.01.2017 21:44:49\] [toby@jabber.n39.eu](mailto:toby@jabber.n39.eu) Ich finde man sollte die Teile durchaus auch nochmal zusätzlich in ein Gehäuse packen, damit man ordentliche Zugentlastung gewähren kann. Schutzleiter durchgeschleift zu Endverbraucher

+++

Ich habe mir gerade mal die Sonoff-Geräte \[0\] genauer angeschaut, von denen inzwischen zwei im Space verbaut sind. Hauptsächlich hat mich interessiert, wie die Spannungsversorgung realisiert ist.

Laut Schematic \[1\] gibt es eine galvanische Trennung zwischen der Netzspannung und der 3.3V-Spannung für den ESP. (Wenn man sich das Board anschaut \[2\], muss der weiß/gelbe Kasten der Trafo sein. Hier wird wahrscheinlich mit sehr hohen Frequenzen gearbeitet, um die notwendige Leistung zu übertragen.)

In meinem ersten Entwurf der Mail hatte ich das Schematic noch nicht gefunden und die Spannungsversorgung sah so aus, als würden die 3.3V nur durch einen Phasennachlauf erzeugt. In dem Fall liegen alle Pozenziale der ESP-Schaltung auf Netzspannungsniveau, selbst wenn der ESP nur 3.3V "sieht". Offenbar gibt es aber wenigstens einen Trafo, sodass eine Potenzialtrennung vorliegt.

Allerdings gibt es auf dem Board keine wirkliche Trennung zwischen Niederspannungs- und Hochspannungsbereichen. Wenn es hier zur Brücken über die Leitungen kommt, liegen auch am ESP schnell mal 230V.

Solange das Gerät geschlossen betrieben wird, ist das nicht relevant. Schlimmstenfalls brennt da etwas durch (und hoffentlich nicht ab). Anders ist das, wenn Kabel aus dem Gerät herausgeführt werden, wie z.B. am Spacestatus-Schalter oder für den Temperatursensor. Jetzt kann man Teile der Platine von außen berühren, damit also ggf. auch mit den 230V in Berührung kommen.

Ich nehme an, dass das so nicht vorgesehen ist und deshalb für die Zertifizierung (wenn es die für das China-Produkt denn regelkonform gab) nicht berücksichtigt werden musste.

Wenn wir zusätzliche Kabel anlöten, muss das Gerät neu evaluiert und ggf. weitere Schutzmaßnahmen getroffen werden. (Z.B. Schutzleiter an allen berührbaren Metallteilen.) Solange wir nicht sicher sind, wollten wir auf Konstruktionen aus sonoff mit herausgeführten Kabeln verzichten.

Berührungen mit Netzspannung wirken sich leider nachhaltig negativ auf die Lebenserwartung aus.

http://hackaday.com/2017/04/04/the-shocking-truth-about-transformerless-power-supplies/
