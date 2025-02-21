---
layout: post
title: "Solarlife MPPT BLE Client – Smarte Solarladung für dein Zuhause"
date: "2025-02-21"
---

In unserem Hackerspace tüfteln wir ständig an neuen Möglichkeiten, um Technologie und Nachhaltigkeit zu verbinden. Heute möchten wir euch ein spannendes Projekt vorstellen: den **Solarlife MPPT BLE Client**. Mit diesem Python-Tool könnt ihr euren **MPPT Solarladeregler** über **Bluetooth Low Energy (BLE)** auslesen und die Daten via **MQTT** an **HomeAssistant** senden.

## Warum ist das spannend?
Viele Solarladeregler haben zwar smarte Funktionen, bieten aber oft keine einfache Möglichkeit, die Werte in ein Smart-Home-System zu integrieren. Genau hier setzt unser Tool an: Es verbindet sich mit dem MPPT-Laderegler, liest regelmäßig die Werte aus und sendet sie an MQTT, wo HomeAssistant sie nahtlos einbinden kann.

Ein Problem bei vielen MPPT-Reglern ist, dass sie nur mit einer **Closed-Source App** geliefert werden. Dank eines [Hinweises](https://github.com/subDesTagesMitExtraKaese/solarlife-mppt-ble-client/pull/1) von GitHub-User [gimzo](https://github.com/gimzo) konnte jedoch ein internes **Modbus-Protokoll** identifiziert und die **Bluetooth-Kommunikation reverse-engineered** werden. Dies ermöglicht eine offene und flexible Nutzung der Geräte. Es werden alle Geräte unterstützt, die mit der *SolarLifeBT*-App kommen.

## So funktioniert es
1. Der Client verbindet sich mit dem **BLE-fähigen Solarladeregler**.
2. Er ruft periodisch relevante Daten wie **Batteriestand, Spannung und Ladeleistung** ab.
3. Diese Daten werden dann an einen **MQTT-Broker** gesendet.
4. HomeAssistant kann die Daten visualisieren und zur Automatisierung nutzen.

    ![Homeassistant Daashbord](https://raw.githubusercontent.com/subDesTagesMitExtraKaese/solarlife-mppt-ble-client/refs/heads/master/images/hass.png)

## Installation
Ihr benötigt **Python 3.10+** sowie die Bibliotheken **Bleak** (für BLE) und **aiomqtt** (für MQTT). Die Einrichtung ist einfach:
```bash
 git clone https://codeberg.org/subDesTagesMitExtraKaese/solarlife-mppt-ble-client.git
 cd solarlife-mppt-ble-client
 python -m venv venv
 source venv/bin/activate
 pip install -r requirements.txt
```
Danach könnt ihr das Skript mit den entsprechenden Verbindungsdetails starten:
```bash
python main.py <BLE-Adresse> --host <MQTT-Host> --port <MQTT-Port>
```

## MQTT-Integration in HomeAssistant
Die gesendeten Daten werden automatisch erkannt und können mit der MQTT Integration in HomeAssistant angezeigt werden.

## Fazit
Dieses Projekt ist perfekt für alle, die ihre Solaranlage smarter machen wollen. Probiert es aus, verbessert den Code und helft uns, nachhaltige Technologien voranzutreiben! Feedback und Pull Requests sind herzlich willkommen. ✨🚀

Mehr Infos findet ihr im [Codeberg-Repository](https://codeberg.org/subDesTagesMitExtraKaese/solarlife-mppt-ble-client).

