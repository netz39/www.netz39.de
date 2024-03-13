require 'icalendar'

module Jekyll
  class IcsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      events = site.collections['events'].docs

      cal = Icalendar::Calendar.new

      events.each do |event|
        title = event.data['title']
        date = event.data['event_date']
        event = Icalendar::Event.new
        event.dtstart = date
        event.dtend = date
        event.summary = title
        cal.add_event(event)
      end
      site.pages << IcalPage.new(site, site.source, 'feed/eo-events', "events.ics", cal)

      puts "Generated events.ics page from #{events.length} events"
    end
  end

  class IcalPage < Page
    def initialize(site, base, dir, name, calendar)
      @site = site
      @base = base
      @dir  = dir
      @name = name

      self.process(name)
      self.content = calendar.to_ical
      self.data = {
        'layout' => nil
      }
    end
  end
end
