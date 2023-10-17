---
layout: post
title: "netcup, froxlor, nginx und automatisierte Tests"
date: "2015-07-30"
categories: 
  - "maschinenraum"
tags: 
  - "froxlor"
  - "netcup"
  - "nginx"
---

Wir haben einige vserver bei [netcup](https://www.netcup.de/) für uns selbst und für [Freifunk Magdeburg](https://md.freifunk.net/), läuft alles super eigentlich. Auf einigen Servern ist wohl [froxlor](https://www.froxlor.org/) vorinstalliert, wir nutzen das nicht. In froxlor gab's wohl die Tage eine [gefährliche Sicherheitslücke](https://forum.netcup.de/anwendung/froxlor/7443-gefaehrliche-sicherheitsluecke-in-froxlor/), über die netcup seine Kunden gestern vorbildlich informiert hat. Heute haben sie anscheinend nochmal bei allen Kunden mit einem (oder mehreren?) Skript geprüft, ob die Kunden da noch angreifbar sind. Im Log von nginx sah das so aus:

46.38.xxx.xxx - - [30/Jul/2015:09:41:18 +0200] "GET /froxlor HTTP/1.1" 200 151 "-" "Wget/1.15 (linux-gnu)"
46.38.xxx.xxx - - [30/Jul/2015:09:41:18 +0200] "GET /froxlor/logs/sql-error.log HTTP/1.1" 200 151 "-" "Wget/1.15 (linux-gnu)"
46.38.xxx.xxx - - [30/Jul/2015:15:59:55 +0200] "GET /froxlor HTTP/1.1" 200 151 "-" "Wget/1.15 (linux-gnu)"
46.38.xxx.xxx - - [30/Jul/2015:15:59:55 +0200] "GET /froxlor/logs/sql-error.log HTTP/1.1" 200 151 "-" "Wget/1.15 (linux-gnu)"
46.38.xxx.xxx - - [30/Jul/2015:16:48:57 +0200] "GET /froxlor HTTP/1.1" 200 151 "-" "Wget/1.15 (linux-gnu)"
46.38.xxx.xxx - - [30/Jul/2015:16:48:57 +0200] "HEAD /froxlor/logs/sql-error.log HTTP/1.1" 200 0 "-" "curl/7.38.0"

Der nginx liefert da seine keineswegs logfiles oder froxlor aus, sondern seine default-Seite mit einem HTTP 200. Was netcup in seinem Skript offenbar nur prüft, ist der Status-Code, nicht aber der Content. Also hab ich jetzt in der nginx-Config folgendes gemacht:

        # froxlor
        location ~ ^/froxlor {
                return 404;
        }

Mal schauen, ob noch mehr Beschwerden kommen jetzt. ;-)

**Update:** die oben genannten Zugriffe konnten wegen der default Config von nginx unter Debian Wheezy zu einem Status Code 200 führen. Auf einem anderen Server bei netcup, der schon mit Debian Jessie läuft, gibt's direkt einen HTTP 404, weil in der default-Config, also die, die keinem extra virtual host zugeordnet ist, folgendes steht:

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

Da kann man sich jetzt natürlich streiten, ob da nicht unsere nginx-Config fehlerhaft war und direkt 404 hätte ausliefern müssen. O:-)
