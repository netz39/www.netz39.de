---
layout: post
title: "Arduino Leonardo mit LM75 und LCD"
date: "2014-02-15"
categories: 
  - "laufende-projekte"
tags: 
  - "arduino"
  - "i²c"
  - "lcd"
  - "lm75"
---

Ein LM75 ist ein digitaler Temperatursensor mit I²C-Schnittstelle, die eine oder andere kennt den Stein vielleicht von der Hauptplatine seines PC. Aus Gründen wollte ich ein bisschen damit spielen und um zu sehen, ob der überhaupt was kann, warum nicht mal eben schnell an einen Arduino stecken? Zum Glück ist das Netz voll von passenden Anleitungen und so war schnell [diese hier](http://books.google.de/books?id=CSei8-a3C30C&pg=PA160&lpg=PA160&dq=lm75+arduino&source=bl&ots=qpDdlbdMlJ&sig=ghvquYx8E_zY9KaU-i-EuA_F1cY&hl=de&sa=X&ei=ol3-UscJkrWEB_TfgYAP&redir_esc=y#v=onepage&q=lm75%20arduino&f=false) als brauchbar ausgemacht. Die Pins 5 bis 7 hab ich einfach auf Masse gelegt. Da die oberen 4 Bits der 7-Bit breiten Slave-Adresse des Steins mit `1001` fest stehen, bedeutet das für die Adresse insgesamt (mit führender Null) `01001000b`. Das behalten wir mal im Hinterkopf, steht aber auch im oben verlinkten Dokument. SDA (Pin 1) und SCL (Pin 2) werden mit dem Arduino verbunden, da gibt's ja freundlicherweise direkt auf der Platine einen passenden Aufdruck. Zum ersten Test benutzt man einfach die serielle Konsole als Ausgabe, sieht als Sketch dann so aus:

#include #define SENSOR\_ADDR  (0x90 >> 1)

void setup() {
  Wire.begin();
  Serial.begin(9600);
}

void loop() {
  Wire.beginTransmission(SENSOR\_ADDR);
  Wire.write((byte)0x00);
  Wire.requestFrom(SENSOR\_ADDR, 1);
  int tempVal;
  if ( Wire.available() ) {
    tempVal = Wire.read();
  }
  Wire.endTransmission();

  Serial.print("Temp 0: ");
  Serial.println(tempVal);
  delay(1000);
}

Das funktioniert soweit, bisschen nervig ist hier die Eigenschaft des Leonardo für USB keinen separaten Stein zu haben, sondern alles über den ATMega32U4 zu machen. Die Verbindung wird einfach ab und zu unterbrochen und das virtuelle serielle Device ist nicht immer ansprechbar. Aber wenn es funktioniert, dann!

Soweit so gut, jetzt noch das HD44780-kompatible alphanumerische LCD. Dazu kann man sich an das passende [Arduino-Tutorial](http://arduino.cc/en/Tutorial/LiquidCrystal) halten. Zu beachten ist hier aber, dass beim Arduino Leonardo die Pins D2 und D3 die selben sind wie SCL und SDA, so dass wir die Verkabelung des Tutorials nicht direkt übernehmen können. Ich habe die Datenleitungen des Display dann einfach an D4 bis D7 gehängt, also um 2 Pins verschoben. Da man sich über die serielle Verbindung zuvor ja schon versichert hat, dass da korrekte Temperaturen ausgelesen werden, kann man die seriellen Sachen wieder aus dem Sketch schmeißen und dann sieht das so aus (mit angepassten Pins):

#include #include #define SENSOR\_ADDR  (0x90 >> 1)

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 7, 6, 5, 4);

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(20, 4);
  // Print a message to the LCD.
  lcd.print("Hello 10!");

  Wire.begin();
}

void loop() {
  Wire.beginTransmission(SENSOR\_ADDR);
  Wire.write((byte)0x00);
  Wire.requestFrom(SENSOR\_ADDR, 1);
  int tempVal;
  if ( Wire.available() ) {
    tempVal = Wire.read();
  }
  Wire.endTransmission();

  lcd.setCursor(0, 2);
  lcd.print("Temp: ");
  lcd.setCursor(6, 2);
  lcd.print(tempVal);
}

Hier nochmal das Bild von meinem Aufbau:

\[caption id="attachment\_1226" align="aligncenter" width="400"\][![Arduino Leonardo mit LM75 und LCD](images/img_0003a-400x300.jpg)](http://www.netz39.de/wp_Jq37/wp-content/uploads/2014/02/img_0003a.jpg) Arduino Leonardo mit LM75 und LCD\[/caption\]

Um den LM75 im SO-8 Package auf das Steckbrett zu bekommen, habe ich übrigens ein selbst geätztes Breakout-Board aus [unserer Eagle-Sammlung](https://github.com/netz39/eagle_parts) benutzt. Davon habe ich noch einige auf Halde, falls da Bedarf bei irgendwem besteht.
