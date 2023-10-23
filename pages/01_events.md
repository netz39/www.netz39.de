---
layout: default
title: Events
permalink: /events
icon: "far fa-calendar"
---

<center>
<h2 class="title"> <i class="far fa-calendar"></i> Events </h2>
</center>

<html lang='de'>
  <head>
    <meta charset='utf-8' />
    <script src='/assets/js/vendor/fullcalendar/index.global.min.js'></script>
    <script src='/assets/js/vendor/fullcalendar/de.global.min.js'></script>
    <script>

      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
          initialView: 'dayGridMonth',
          height: "auto",
          locale: 'de',
          events: '/calendar-data',
          weekNumbers: true,
          headerToolbar:
          {
            left: 'today',
            center: 'title',
            right: 'prev,next'
          }
        });
        calendar.render();
      });

    </script>
  </head>
  <body>
    <div id='calendar' style="width:80%; margin: auto;"></div>
  </body>
</html>
