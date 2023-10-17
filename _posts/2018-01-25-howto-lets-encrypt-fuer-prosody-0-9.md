---
layout: post
title: "HowTo: Let's Encrypt für prosody 0.9"
date: "2018-01-25"
categories: 
  - "maschinenraum"
tags: 
  - "debian"
  - "dehydrated"
  - "howto"
  - "jabber"
  - "lets-encrypt"
  - "nginx"
  - "prosody"
---

Für unseren Jabber- bzw. XMPP-Server unter [jabber.n39.eu](http://jabber.n39.eu/) brauchen wir ein Zertifikat für die verschlüsselte Kommunikation zwischen Clients und Server bzw. für die Kommunikation der Server untereinander. Früher benutzten wir da eins von [CAcert](http://www.cacert.org/), was ab und an zu Nachfragen der Nutzer führte. Seit einiger Zeit kann man über [Let's Encrypt](https://letsencrypt.org/) kostenfrei SSL-/TLS-Zertifikate bekommen und genau so eins kommt nun für unseren Jabber-Server zum Einsatz. Wie? So:

Auf der virtuellen Maschine läuft als XMPP-Server [prosody](https://prosody.im/), noch in Version 0.9.x aus [Debian](https://www.debian.org/) 8 (jessie) bzw. 9 (stretch). Als Client für das ACME-Protokoll zur Kommunikation mit den Servern von Let's Encrypt kommt [dehydrated](https://github.com/lukas2511/dehydrated) zum Einsatz, das mittlerweile auch einfach über die Debian-Paketverwaltung installiert werden kann. Für das Challenge-Response benutzen wir die webroot-Methode zusammen mit dem Webserver [nginx](http://nginx.org/).

## prosody

Wir fahren hier eine Konfiguration, die sich an den Vorgaben vom Debian-Paket orientiert. Für den VirtualHost _jabber.n39.eu_ haben wir folgenden Ausschnitt aus der Konfiguration:

VirtualHost "jabber.n39.eu"

        ssl = { 
                key = "/etc/prosody/certs/jabber.n39.eu.key";
                certificate = "/etc/prosody/certs/jabber.n39.eu.pem";
                dhparam = "/etc/prosody/certs/dh-2048.pem";
                -- TODO for post 0.10 see http://prosody.im/doc/advanced\_ssl\_config again
                options = { "no\_sslv2", "no\_sslv3", "no\_ticket", "no\_compression", "cipher\_server\_preference", "single\_dh\_use", "single\_ecdh\_use" };
        }

Das dient hier im wesentlichen zu zeigen, wo bei uns Key und Zertifikat liegen. Die Zertifikatsdatei muss auch Root-Zertifikat und Intermediate-Zertifikate in der richtigen Reihenfolge enthalten. Details dazu gibt es in der Doku zu prosody ([Certificates](https://prosody.im/doc/certificates)), aber wir bekommen das später fertig von dehydrated.

## nginx

Hier haben wir uns eng an die Doku von dehydrated ([wellknown.md](https://github.com/lukas2511/dehydrated/blob/master/docs/wellknown.md)) gehalten und in unser bestehenden nginx config für [jabber.n39.eu](http://jabber.n39.eu/) den alias für das well-known-Verzeichnis ergänzt:

        location /.well-known/acme-challenge {
                alias /var/www/dehydrated;
        }

Auch dieser Pfad wird gleich bei der Konfiguration von dehydrated noch wichtig sein. Das Verzeichnis `/var/www/dehydrated` hatten wir zuvor angelegt und die Rechte passend für den Webserver gesetzt:

mkdir -p /var/www/dehydrated
chown -R www-data:www-data /var/www/dehydrated
chmod 2775 /var/www/dehydrated

Wer hier noch gar keine Konfiguration hat, legt sich einen neuen virtual host in nginx an.

## dehydrated

### Basis-Setup

Hier fahren wir eine Mischung aus den Vorgaben von dehydrated und vom Debian-Paket, die Konfiguration ist aber sehr übersichtlich. Die Datei `/etc/dehydrated/domains.txt` wenig überraschend:

jabber.n39.eu conference.jabber.n39.eu

Interessanter möglicherweise `/etc/dehydrated/config` – hier haben wir die Variable `WELLKNOWN` angepasst und die Variablen `CONTACT_EMAIL` und `LICENSE` ergänzt. Letzteres ist notwendig, weil Let's Encrypt hier mittlerweile eine neuere Version abnicken lässt, als noch im alten Debian-Paket voreingestellt ist. Lässt man das auf default, wird der Aufruf von dehydrated aber fehlschlagen. Die passende URL bekommt man dann in der Ausgabe oder in einem Logfile (das weiß ich nicht mehr genau).

#############################################################
# This is the main config file for dehydrated               #
#                                                           #
# This is the default configuration for the Debian package. #
# To see a more comprehensive example, see                  #
# /usr/share/doc/dehydrated/examples/config                 #
#                                                           #
# For details please read:                                  #
# /usr/share/doc/dehydrated/README.Debian                   #
#############################################################

CONFIG\_D=/etc/dehydrated/conf.d
BASEDIR=/var/lib/dehydrated
#WELLKNOWN="${BASEDIR}/acme-challenges"
WELLKNOWN="/var/www/dehydrated"
DOMAINS\_TXT="/etc/dehydrated/domains.txt"

CONTACT\_EMAIL="admin@netz39.de"
LICENSE="https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf"
#CA="https://acme-staging.api.letsencrypt.org/directory"

Bevor wir die notwendigen Hooks erstellen, rufen wir dehydrated einmal auf:

dehydrated -c

Das sollte erfolgreich durchlaufen. Danach sind unterhalb von `/var/lib/dehydrated` allerlei neue Dateien zu finden, unter anderem auch unser Key und Zertifikat. Zum ersten Test hatte ich diese dann per Hand ins Verzeichnis von prosody geschoben und den neu gestartet. Funktionierte auf Anhieb. :-)

### Automatisierung

Da die von Let's Encrypt ausgegebenen Zertifikate nur eine Gültigkeitsdauer von 90 Tagen haben, will man das Erneuern derselben natürlich automatisieren. Folgende Schritte sind notwendig:

- vor Ablauf der 90 Tage neues Zertifikat holen
- Zertifikat zu prosody kopieren und Rechte setzen
- prosody Zertifikate neu laden lassen

Den ersten Punkt erschlagen dehydrated und cron. Man lässt cron einfach regelmäßig dehydrated aufrufen. Einmal `crontab -e` (als root) eintippern und folgende Zeile ergänzen:

39 4 \* \* mon,thu dehydrated -c

Hier wird dehydrated jetzt also Montag und Donnerstag um 4:39 Uhr aufgerufen, sollte hoffentlich reichen um rechtzeitig vor Ablauf des Zertifikats ein neues zu bekommen.

Fehlt noch der Teil »Zeug aus `/var/lib/dehydrated` nach `/etc/prosody/certs` bekommen«. Wir nutzen dazu [Config on per-certificate base](https://github.com/lukas2511/dehydrated/blob/master/docs/per-certificate-config.md) um ein nur für das Zertifikat des Jabber-Servers gültiges Hook-Skript nutzen zu können. Dazu wurde im Pfad `/var/lib/dehydrated/certs/jabber.n39.eu` die Datei `config` angelegt und wie folgt befüllt:

HOOK="${CERTDIR}/jabber.n39.eu/hook.sh"

Ins selbe Verzeichnis haben wir dann `hook.sh` aus `/usr/share/doc/dehydrated/examples` kopiert und angepasst. (Für alle Nicht-Debian-Nutzer gibt es das komplette Skript (ohne Anpassungen) auch upstream: [hook.sh](https://github.com/lukas2511/dehydrated/blob/master/docs/examples/hook.sh))

function deploy\_cert {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"

    # This hook is called once for each certificate that has been
    # produced. Here you might, for instance, copy your new certificates
    # to service-specific locations and reload the service.
    #
    # Parameters:
    # - DOMAIN
    #   The primary domain name, i.e. the certificate common
    #   name (CN).
    # - KEYFILE
    #   The path of the file containing the private key.
    # - CERTFILE
    #   The path of the file containing the signed certificate.
    # - FULLCHAINFILE
    #   The path of the file containing the full certificate chain.
    # - CHAINFILE
    #   The path of the file containing the intermediate certificate(s).
    # - TIMESTAMP
    #   Timestamp when the specified certificate was created.

        PROSODY\_CERT\_DIR='/etc/prosody/certs'
        service prosody stop
        pushd ${PROSODY\_CERT\_DIR}
        mv "${DOMAIN}.key" "${DOMAIN}.$(date --iso-8601).key"
        cp "${KEYFILE}" "${DOMAIN}.key"
        chmod 600 "${DOMAIN}.key"
        chown prosody:prosody "${DOMAIN}.key"

        mv "${DOMAIN}.pem" "${DOMAIN}.$(date --iso-8601).pem"
        cp "${FULLCHAINFILE}" "${DOMAIN}.pem"
        chmod 600 "${DOMAIN}.pem"
        chown prosody:prosody "${DOMAIN}.pem"

        popd
        service prosody start
}

Wie man leicht sieht, tun wir hier folgendes:

- eine Variable mit dem Pfad für die certs von prosody anlegen
- prosody stoppen (hier nutzen wir aus den [Prosody Community Modules](https://modules.prosody.im/) übrigens [mod\_graceful\_shutdown](https://modules.prosody.im/mod_graceful_shutdown.html))
- alten Key sichern
- neuen Key hinkopieren
- Rechte setzen
- das gleiche für das Cert nochmal, wichtig das `${FULLCHAINFILE}` nutzen!
- prosody wieder starten
- zwischendrin werden die Funktionen `pushd` und `popd` der Bash genutzt

Das `hook.sh` dann noch mit `chmod` ausführbar machen, fertig. :-)

**Update:** hier wurde bewusst der Neustart des prosody gewählt, weil der leider ein hässliches Speicherleck hat. So wird er alle paar Wochen mal neu gestartet. Das ist ggf. für die Nutzer unschön, aber uns geht unsere VM nicht krachen. O:-)
