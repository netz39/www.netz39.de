---
author: lespocky
layout: post
title: "Keysigningparty"
date: "2017-10-12"
categories: 
  - "veranstaltung"
tags: 
  - "gnupg"
  - "keysigning"
  - "openpgp"
  - "pgp"
feature-img: "assets/img/post-img/2017/5421_dba1.jpeg"
thumbnail: "assets/img/post-img/2017/5421_dba1.jpeg"
---

Wir haben schon länger keine Keysigningparty gemacht. Mittlerweile gab es die eine oder Anfrage dafür und deswegen machen wir wieder eine. Termin ist **Freitag, der 20. Oktober 2017** um **19:30 Uhr** und wir machen das in unseren Räumen in der Leibnizstraße 32 in Magdeburg.

## Was ist Keysigning?

PGP arbeitet mit asymmetrischer Verschlüsselung und Schlüsselpaaren. Da jeder sich beliebig viele Schlüssel mit beliebigen Namen und Adressen erstellen könnte, kommt die Frage auf, ob ein öffentlicher Schlüssel tatsächlich zur vorgegebenen Person gehört und vertrauenswürdig ist. Um das abzusichern, nutzt man PGP selbst und unterschreibt sich gegenseitig die Schlüssel, die man persönlich überprüft hat. Auf diese Weise entsteht ein Vertrauensnetzwerk (web of trust) das es ermöglicht anhand der unterschriebenen bzw. bestätigten Schlüssel eine Aussage über die Verlässlichkeit eines Schlüssels zu treffen.

Um dieses Vertrauensnetzwerk aufzubauen, trifft man sich, prüft anhand eines Ausweisdokuments die Identität des Gegenübers und unterschreibt im Anschluss dessen Schlüssel. Das ist Keysigning.

## Anmeldung

Zur Keysigningparty ist eine **Anmeldung im Voraus** erforderlich. Dazu schicken interessierte bitte den Fingerabdruck ihres Schlüssels an [alex@netz39.de](mailto:alex@netz39.de) per E-Mail.

## Vorbereitung

Lest Euch bitte die Schritte **genau** durch. Es ist schon vorgekommen, dass Leute ohne Liste oder ohne Prüfsummen erschienen sind.

- Falls noch nicht vorhanden, erstellt man sich sein eigenes Schlüsselpaar. **Hilfe** dazu gibt es im Netz oder **im Voraus vor Ort im Hackerspace**.
- Den öffentlichen Schlüssel lädt man wenn möglich auf einen Keyserver. (Es würde auch ohne gehen, aber das macht es für alle Teilnehmer unnötig umständlich.)
- Die **Anmeldefrist** läuft bis zum **Dienstag, 17. Oktober**!
- Für die Anmeldung bitte eine E-Mail mit dem persönlichen Fingerprint an [alex@netz39.de](mailto:alex@netz39.de) schicken. Die Ausgabe von `gpg --fingerprint KEYID` genügt.
- Nach Ablauf der Anmeldefrist vor Beginn der Veranstaltung lade die Liste der Teilnehmer herunter. **Prüfe, ob Dein Schlüssel aufgelistet ist und der Fingerprint übereinstimmt.** Falls nicht, frage per E-Mail an o.g. Adresse nach!
- Die endgültige Liste wird kurz vor der Veranstaltung (Donnerstag) bereit gestellt und alle Teilnehmer\*innen erhalten nochmal eine E-Mail als Erinnerung.
- Berechne die MD5, SHA1 und SHA256 Prüfsummen über die heruntergeladene Textdatei der endgültigen Liste. Dies kann mit den Programmen _md5sum_, _sha1sum_ und _sha256sum_ geschehen. Alternativ kann man direkt GnuPG benutzen: `gpg --print-mds DATEI`. Ist man nicht unter Linux unterwegs, hat sich das Programm _HashTab Shell Extension_ als brauchbar erwiesen.
- Trage diese Werte danach (!) in die eigene Liste ein und drucke die Liste aus oder drucke die Liste aus und trage die Prüfsummen ein. Wichtig ist, dass die Prüfsummen über die unveränderte, heruntergeladene Liste berechnet werden.
- Bringe die ausgedruckte Liste zusammen mit einem Ausweisdokument mit zur Veranstaltung! (Nicht vergessen!)

## Ablauf am Abend der Veranstaltung

Am Veranstaltungsabend hat jeder seine Liste ausgedruckt und dabei, die Prüfsummen notiert und ein gültiges (Ablaufdatum prüfen!) Ausweisdokument bei sich.

Zu Beginn prüfen wir gemeinsam, ob jeder die selbe Liste hat, indem wir die Prüfsummen vergleichen. Ist sichergestellt, dass jeder die selbe Liste dabei hat, stellen wir uns in der Reihenfolge der Liste auf und prüfen dann gegenseitig Dokumente und Fingerprints. Dazu sollte **im Voraus** jeder geprüft haben, ob sein Fingerprint auf der Liste korrekt ist!

Nach der Veranstaltung geht jeder erstmal nach Hause, das eigentliche Unterschreiben erfolgt nicht vor Ort.

## Nachbereitung zu Hause

Jeder hat jetzt eine Liste mit abgehakten Schlüsseln und sich damit ohne große Ablenkung in Ruhe zu Hause vor seinen Rechner gesetzt. Es geht nun darum die Schlüssel aller Teilnehmer zu signieren, die tatsächlich vor Ort waren, bestätigt hatten, dass ihr Fingerprint auf der Liste korrekt ist und ein gültiges Ausweisdokument vorweisen konnten. Bitte signiert keine Schlüssel von Leuten, die zwar auf der Liste angemeldet waren, aber gar nicht da waren!

Es gibt zwei wichtige Dinge, die zu beachten sind:

1. Prüft vor dem Bestätigen der Signatur, dass der von der Software gezeigte Fingerprint mit dem auf Eurer Teilnehmerliste übereinstimmt! (Sonst hätten wir uns das Treffen sparen können. ;-) )
2. Es wird als schlechtes Benehmen angesehen fremder Leute öffentliche Schlüssel auf den Keyserver zu laden. Signaturen sollten exportiert und per verschlüsselter Mail an den Inhaber des zuvor signierten Schlüssels geschickt werden. Der Inhaber kann dann entscheiden, ob er oder sie den neu signierten Schlüssel auf einem Keyserver veröffentlicht.

Für [Debian](https://www.debian.org/)\- bzw. Linuxnutzer automatisiert das Perl-Skript _caff_ aus dem Paket [signing-party](https://packages.debian.org/stretch/signing-party) diesen Prozess. Im einfachsten Fall ruft man es mit den KeyIDs als Parameter auf. Es empfiehlt sich hier aber, mal die manpage zu lesen und sich caff einmalig nach seinen Wünschen einzurichten. Dann kann man bspw. auch die Teilnehmerliste nochmal bearbeiten und für caff als Eingabe benutzen. Für größere Anzahlen Teilnehmer oder häufigere Besuche von Keysigningpartys ist das Skript sehr zu empfehlen. Man spart sich viel Tipperei und, Bonus: caff exportiert die Signaturen einzeln pro UID und schickt sie automatisch verschlüsselt an die entsprechenden E-Mail-Adressen.

Viele benutzen das Plugin [Enigmail](https://addons.mozilla.org/de/thunderbird/addon/enigmail/) für Mozilla Thunderbird. Auch damit kann man Schlüssel unterschreiben. Im [Handbuch zu Enigmail](https://enigmail.wiki/Key_Management#Signing_other_people.27s_keys) ist dies kurz erklärt. Das Grundprinzip ist auch hier das gleiche. Nach dem Signieren, exportiert man den public key (die neue Signatur hängt dann da dran) und packt den in den Anhang einer verschlüsselten Mail an den Schlüsselinhaber.

Ähnlich kann man auch vorgehen, wenn man _gpg_ auf der Kommandozeile manuell bedient. Die Dokumentation zu GnuPG verrät da gewiss Details zum Vorgehen.

Umgekehrt werdet Ihr Signaturen per E-Mail erhalten. Importiert diese Dateien einfach mit `gpg --import` oder im GUI Eurer Wahl. Danach könnt Ihr Euren eigenen Schlüssel auf einen Keyserver hochladen, so dass andere Leute die Signaturen sehen können.

**Update:** Liste der Teilnehmer\*innen entfernt.
