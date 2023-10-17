---
layout: post
title: "Keysigningparty"
date: "2013-09-08"
categories: 
  - "veranstaltung"
tags: 
  - "gnupg"
  - "keysigning"
  - "pgp"
---

# Keysigningparty

## Pretty Good Privacy – Verschlüsselung für E-Mail und mehr

In den letzten Wochen ist aus Vermutungen, dass das Internet umfassend überwacht wird, traurige Gewissheit geworden. Die Geheimdienste von Großbritannien und den U.S.A. schnorcheln alle Daten ab, derer sie habhaft werden können. Einen technischen Schutz der eigenen Privatsphäre kann Verschlüsselung bieten. Wie man E-Mails zwischen Empfänger und Absender verschlüsseln kann und warum das überhaupt sicher ist, wird Stefan Schumacher vom Magdeburger Institut für Sicherheitsforschung am Mittwoch, dem 9. Oktober in einem Einführungsvortrag im Netz39 e.V. erzählen. Beginn ist 19:00 Uhr in den Räumen in der Leibnizstraße 32.

Im Anschluss wird es eine Keysigningparty geben, wo Nutzer, die bereits mit der Materie vertraut sind, gegenseitig ihre öffentlichen Schlüssel unterschreiben können.

## Was ist Keysigning?

PGP arbeitet mit asymmetrischer Verschlüsselung und Schlüsselpaaren. Da jeder sich beliebig viele Schlüssel mit beliebigen Namen und Adressen erstellen könnte, kommt die Frage auf, ob ein öffentlicher Schlüssel tatsächlich zur vorgegebenen Person gehört und vertrauenswürdig ist. Um das abzusichern, nutzt man PGP selbst und unterschreibt sich gegenseitig die Schlüssel, die man persönlich überprüft hat. Auf diese Weise entsteht ein Vertrauensnetzwerk (web of trust) das es ermöglicht anhand der unterschriebenen bzw. bestätigten Schlüssel eine Aussage über die Verlässlichkeit eines Schlüssels zu treffen.

Um dieses Vertrauensnetzwerk aufzubauen, trifft man sich, prüft anhand eines Ausweisdokuments die Identität des Gegenübers und unterschreibt im Anschluss dessen Schlüssel. Das ist Keysigning.

## Anmeldung

Zur Keysigningparty ist eine Anmeldung im Voraus erforderlich. Dazu schicken interessierte bitte den Fingerabdruck ihres Schlüssels an [alex@netz39.de](mailto:alex@netz39.de) per E-Mail.

## Vorbereitung

- Falls noch nicht vorhanden, erstellt man sich sein eigenes Schlüsselpaar. Hilfe dazu gibt es im Netz oder im Voraus vor Ort im Hackerspace.
- Den öffentlichen Schlüssel lädt man wenn möglich auf einen Keyserver. (Es würde auch ohne gehen, aber das macht es für alle Teilnehmer unnötig umständlich.)
- Die **Anmeldefrist** läuft bis zum **5\. Oktober**!
- Für die Anmeldung bitte eine E-Mail mit dem persönlichen Fingerprint an [alex@netz39.de](mailto:alex@netz39.de) schicken. Die Ausgabe von `gpg --fingerprint KEYID` genügt.
- Nach Ablauf der Anmeldefrist vor Beginn der Veranstaltung lade die Liste der Teilnehmer herunter. **Prüfe, ob Dein Schlüssel aufgelistet ist und der Fingerprint übereinstimmt.** Falls nicht, frage per E-Mail an o.g. Adresse nach!
- Die endgültige Liste wird kurz vor der Veranstaltung bereit gestellt und alle Teilnehmer\*innen erhalten nochmal eine E-Mail als Erinnerung.
- Berechne die MD5, SHA1 und SHA256 Prüfsummen über die heruntergeladene Textdatei der endgültigen Liste. Dies kann mit den Programmen _md5sum_, _sha1sum_ und _sha256sum_ geschehen. Alternativ kann man direkt GnuPG benutzen: `gpg --print-mds DATEI`. Ist man nicht unter Linux unterwegs, hat sich das Programm _HashTab Shell Extension_ als brauchbar erwiesen.
- Trage diese Werte danach (!) in die eigene Liste ein und drucke die Liste aus oder drucke die Liste aus und trage die Prüfsummen ein. Wichtig ist, dass die Prüfsummen über die unveränderte, heruntergeladene Liste berechnet werden.
- Bringe die ausgedruckte Liste zusammen mit einem Ausweisdokument mit zur Veranstaltung! (Nicht vergessen!)

## Ablauf am Abend der Veranstaltung

Am Veranstaltungsabend werden wir uns nach dem Vortrag versammeln. Dazu hat jeder seine Liste und ein gültiges (Ablaufdatum prüfen!) Ausweisdokument dabei.

Zu Beginn prüfen wir gemeinsam, ob jeder die selbe Liste hat, indem wir die Prüfsummen vergleichen. Ist sichergestellt, dass jeder die selbe Liste dabei hat, stellen wir uns in der Reihenfolge der Liste auf und prüfen dann gegenseitig Dokumente und Fingerprints. Dazu sollte im Voraus jeder geprüft haben, ob sein Fingerprint auf der Liste korrekt ist!

Nach der Veranstaltung können zu Hause …

**Update:** Liste der Teilnehmer\*innen entfernt.
