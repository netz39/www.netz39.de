---
layout: default
title: Events
permalink: /events
icon: "far fa-calendar"
position: 0
---

<center>
<h2 class="title"> <i class="far fa-calendar"></i> Events </h2>
</center>

<html lang='de'>
  <head>
    <meta charset='utf-8' />
    <script src='/assets/js/vendor/rrule.min.js'></script>
    <script src='/assets/js/vendor/fullcalendar/index.global.min.js'></script>
    <script src='/assets/js/vendor/fullcalendar/de.global.min.js'></script>
    <script src='/assets/js/vendor/fullcalendar/fullcalendar-rrule.global.min.js'></script>
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

      const icalFeedUrls = {};
    </script>

  </head>
  <body>
    <div class="posts">
      {% for event in site.events %}
        {% if event.event.rrule %}
          <div class="post-teaser">
              {% if event.image %}
              <div class="post-img">
                  <a aria-label="{{ event.title }}" href="{{ event.url | relative_url }}">
                      <img alt="{{ event.title }}" src="{{ event.image | relative_url }}">
                  </a>
              </div>
              {% endif %}
              <span>
                <header>
                  <h1>
                    <a aria-label="{{ event.title }}" class="post-link" href="{{ event.url | relative_url }}">
                      {{ event.title }}
                    </a>
                  </h1>
                  {% include blog/post_info.liquid author=event.author date=event.event.start rrule=event.event.rrule %}
                </header>
                {% if site.excerpt or site.theme_settings.excerpt %}
                    <div class="excerpt">
                        {% if site.excerpt == "truncate" %}
                          {{ event.content | strip_html | truncate: '250' | escape }}
                        {% else %}
                          {{ event.excerpt | strip_html | escape }}
                        {% endif %}
                    </div>
                {% endif %}
            </span>
          </div>
        {% endif %}
      {% endfor %}
    </div>
    <div id='calendar' style="width:95%; margin: auto; margin-top: 50px;"></div>
        <div style="display: flex; align-items: center; margin-top: 50px; width: 100%; padding: 15px;">
            <h3 style="margin: auto; margin-right: 0px">ICal Feeds</h3>
            <div style="display: flex; flex-direction: column; margin: auto; margin-left: 15px">
              {% for feed in site.pages %}
                  {% assign name = feed.name | downcase %}
                  {% if name contains 'ics' and feed.name contains 'events' or feed.name contains 'non-recurring' %}
                    <div style="display: flex; align-items: center; width: 100%;">
                      <p style="margin-bottom: 0px; margin-right: 10px;">
                        {% if feed.name contains 'events' %}
                          everything
                        {% else %}
                          {{ feed.name | replace: '.ics', '' }}
                        {% endif %}</p>
                      <code id="{{feed.name}}-url" style="box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1); font-family: monospace;"></code>
                      <a id="{{feed.name}}-cpbtn" style="margin-left: 10px; margin-top: 0px; margin-bottom: 0px;">
                          <i class="fas fa-copy" title="In Zwischenablage kopieren"></i>
                      </a>
                    </div>
                  {% endif %}
              {% endfor %}
            </div>
    </div>

    {% for feed in site.pages %}
      {% assign name = feed.name | downcase %}
      {% if name contains 'ics' %}
        <script>
          icalFeedUrls["{{feed.name}}"] = { url: "{{site.url}}/feed/eo-events/{{feed.name}}", btn: document.getElementById("{{feed.name}}-cpbtn")};

          // set text in HTML element "{{feed.name}}-url" to the URL
          document.getElementById("{{feed.name}}-url").textContent = icalFeedUrls["{{feed.name}}"].url;

          icalFeedUrls["{{feed.name}}"].btn.addEventListener('click', () => {
              const tempInput = document.createElement('input');
              tempInput.value = icalFeedUrls["{{feed.name}}"].url;
              document.body.appendChild(tempInput);
              tempInput.select();
              document.execCommand('copy');
              document.body.removeChild(tempInput);
              alert('URL wurde in die Zwischenablage kopiert!');
          });
        </script>
      {% endif %}
    {% endfor %}

  </body>
</html>
