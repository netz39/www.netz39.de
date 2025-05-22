import { Calendar } from "@fullcalendar/core";
import iCalendarPlugin from "@fullcalendar/icalendar";
import dayGridPlugin from "@fullcalendar/daygrid";

/**
 *
 * @param {*} feeds is an array of objects
 * example:
 * [{
 *    url: "www.netz39.de/test.ics",
 *    format: "ics",
 *    color: "yellow",
 *    textColor: "black"
 * }]
 */
export const buildCalendar = function (feeds) {
  document.addEventListener("DOMContentLoaded", function () {
    var calendarEl = document.getElementById("calendar");
    var calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, iCalendarPlugin],
      initialView: "dayGridMonth",
      height: "auto",
      locale: "de",
      firstDay: 1,
      eventSources: feeds,
      weekNumbers: true,
      headerToolbar: {
        left: "today",
        center: "title",
        right: "prev,next",
      },
    });
    calendar.render();
  });
};

export default buildCalendar;
