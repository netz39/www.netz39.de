require 'icalendar'
require 'redcarpet'
require 'redcarpet/render_strip' 

module Jekyll
  class IcsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      events = site.collections['events'].docs
      default_organizer = "Netz39 Team <kontakt@netz39.de>"
      default_location = "Netz39 e.V., Leibnizstraße 32, 39104 Magdeburg"
      default_duration = Rational(4, 24)
      cal = Icalendar::Calendar.new

      # Define Europe/Berlin timezone with standard rules (incl. DST)
      cal.timezone do |t|
        t.tzid = "Europe/Berlin"
         # Daylight Saving Time (DST) adjustments (if applicable)
        t.daylight do |d|
          d.tzoffsetfrom = "-0100"
          d.tzoffsetto = "-0200"
          d.dtstart = "19700329T020000"
          d.tzname = "CEST"
        end
         # Standard Time definition
        t.standard do |s|
          s.tzoffsetfrom = "-0200"
          s.tzoffsetto = "-0100"
          s.dtstart = "19701025T030000"
          s.tzname = "CET"
        end
      end

      events.each do |event|
        title = event.data['title']
        start_date = event.data.dig('event', 'start') || event.data['event_date']
        end_date = event.data.dig('event', 'end') || event.data['event_date'] || start_date + default_duration
        organizer = event.data.dig('event', 'organizer') || default_organizer
        location = event.data.dig('event', 'location') || default_location

        # Skip events older than 365 days
        next if start_date.to_date < (Date.today - 365)

        # Remove image URLs from description
        content = event.content
        content.gsub!(/\!\[.*?\]\((.*?)\)/, '')

        # Render Markdown content to plain text
        markdown_parser = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
        description = markdown_parser.render(content) + "\nMehr Infos unter #{site.config['url']}#{event.url}"

        # Create new event and set its properties
        ical_event = Icalendar::Event.new
        if start_date > end_date
          raise StandardError.new "#{File.basename(event.path)}: Start date must not be greater than end date"
        end
        if start_date < end_date
          ical_event.dtstart = Icalendar::Values::DateTime.new(start_date, 'tzid' => 'Europe/Berlin')
          ical_event.dtend   = Icalendar::Values::DateTime.new(end_date, 'tzid' => 'Europe/Berlin')
        else
          ical_event.dtstart = Icalendar::Values::Date.new(start_date)
          ical_event.dtend = Icalendar::Values::Date.new(end_date)
        end
        ical_event.summary = title
        ical_event.description = description
        ical_event.organizer = organizer
        ical_event.location = location
        cal.add_event(ical_event)
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
