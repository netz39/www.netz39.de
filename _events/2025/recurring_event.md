---
layout: event
title: "recurringEvent"
author: MaxMustermann # optional, soll angegeben werden, wenn du der Ansprechpartner des Events bist
event:
  start: 2025-04-16 19:00:00 # Datum, an dem das Event stattfindet. Die Zeit ist optional
  end: 2025-04-16 21:00:00 # optional, Zeitpunkt, an dem das Event endet
  organizer: "Netz39 Team <kontakt@netz39.de>" # optional, Kontaktdaten im ical Event
  location: "Netz39 e.V." # optional, Ort des Events
  rrule: "DTSTART=20250416T190000Z;FREQ=MONTHLY;INTERVAL=1;BYDAY=2FR" # follows https://icalendar.org/iCalendar-RFC-5545/3-3-10-recurrence-rule.html
---
