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
    <script src='/assets/js/vendor/fullcalendar@6.1.9/index.global.min.js'></script>
    <script src='/assets/js/vendor/fullcalendar@6.1.9/de.global.min.js'></script>
    <script src='/assets/js/vendor/jquery-3.7.1.min.js'></script>
    <script src='/assets/js/vendor/ics/ics.min.js'></script>
    <script src='/assets/js/vendor/ics/FileSaver.js'></script>
    <script type="text/javascript">

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

        cal = ics();

        $.getJSON('/calendar-data', function(data) 
        {
          $.each(data, function(index, entry) 
          {
            cal.addEvent(entry.title, '', '', entry.start, entry.start);
          });
        });
    });
    </script>
  </head>
  <body>
    <div id='calendar' style="width:80%; margin: auto;"></div>
    <center>
      <a href="#" class="button" onclick="javascript:cal.download('Netz39')">
              <i class="far fa-calendar-plus"> Download ICS</i>
      </a>
    </center>
  </body>
</html>
