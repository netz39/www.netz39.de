---
author: lespocky
layout: post
title: "Name Based Vhost, Dual Stack, and SSL at the Same Time with Nginx"
date: "2013-10-14"
categories: 
  - "maschinenraum"
tags: 
  - "debian"
  - "ipv6"
  - "nginx"
feature-img: "https://cdn.netz39.de/img/post-img/2013/console-feature.jpg"
thumbnail: "https://cdn.netz39.de/img/post-img/2013/console-feature.jpg"
---

Netzwerk und Server in so einem Space am Laufen zu halten, kostet schon mal das eine oder andere graue Haar, aber wieviele mir [nginx](http://nginx.org/) schon bereitet hat, mag ich grad nicht mehr zählen. Von vorn: weil wir coole Hacker sind, haben wir in unserem lokalen Netz im Space auch IPv6 trotz IPv4-only-Anschluss und NAT, [SixXS](https://www.sixxs.net/) und [fli4l](http://www.fli4l.de/) machen's möglich. Im lokalen Netz laufen einige Dienste, unter anderem auch die [Space API](http://spaceapi.net/). Für den HTTP-Zugriff von draußen über IPv4 haben wir mit nginx einen Reverse Proxy aufgesetzt auf einem Debian Wheezy, wir reden also von Version 1.2.1 plus Patches. Den aktuellen Status kann man abrufen, so:

[![](https://spaceapi.n39.eu/state.png)](https://spaceapi.n39.eu/state.png)

Die URLs sollen von draußen wie drinnen erreichbar sein und zwar am besten mit dem selben FQDN über IPv4 und IPv6 und das hat mir einiges Kopfzerbrechen bereitet. Alle Anfragen von intern _und_ extern landen erstmal auf dem Reverse Proxy (CNAME-Records FTW) und der leitet das dann noch an einen anderen Rechner im lokalen Netz weiter. Mal ging der Zugriff von außen nicht, mal nicht von innen, mal nicht über IPv6 usw. und da der ngnix nicht nur diese eine Aufgabe hat – andere Dienste erfordern HTTPS – war das ganze bisschen knifflig. Dass es mit IPv6 ein Problem gab, wurde irgendwie mit Hilfe von tcpdump und Wireshark klar, weil sich Zugriffe von innen und außen genau dadurch unterschieden, dass hier das eine und dort das andere genutzt wurde. Schlussendlich auf den Trichter gebracht haben mich die Fehlermeldungen von nginx selbst und ein [Eintrag bei serverfault](http://serverfault.com/questions/277653/nginx-name-based-virtual-hosts-on-ipv6 "nginx name-based virtual hosts on IPv6").

Lange Rede kurzer Sinn, hier die entscheidenden Zeilen der Config, den Rest bitte selbständig hinzufügen.

Für den default host:

        server {
                listen   80 default_server;
                listen   [::]:80 default_server ipv6only=on;
        }
        server {
                listen   [::]:443 default_server;
                ssl on;
        }

Und dann für alle virtual hosts jeweils:

        server {
                listen  80;
                listen  [::]:80;
        }
        server {
                listen  [::]:443;
                ssl on;
        }

Das Verrückte ist, dass sich die _listen_ Angaben je nach default und vhost unterscheiden und dass man bei SSL aber wieder auf die zweite Zeile für IPv4 verzichten muss und beides so geht. Da kommt doch kein Mensch drauf!
