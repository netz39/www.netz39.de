require 'icalendar'
require 'redcarpet'
require 'redcarpet/render_strip' 

def file_path_to_uid(file_path)
  # Generate a SHA256 hash from the file path
  hashed_path = Digest::SHA256.hexdigest(file_path)
  
  # for ics uid requirements see:
  # https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.4.7 
  uid = "#{hashed_path}@netz39.de"
  
  uid
end

module Jekyll
  class IcsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      events = site.collections['events'].docs
      default_organizer = "Netz39 Team <kontakt@netz39.de>"
      default_location = "Netz39 e.V., Leibnizstraße 32, 39104 Magdeburg"
      default_duration = Rational(4, 24)
      cals = Hash.new()
      calAllEvents = Icalendar::Calendar.new
      cals[:events] = calAllEvents

      events.each do |event|
        title = event.data['title']
        start_date = event.data.dig('event', 'start') || event.data['event_date']

        # Skip events older than 365 days
        next if !start_date || start_date.to_date < (Date.today - 365)

        end_date = event.data.dig('event', 'end') || event.data['event_date'] || start_date + default_duration
        organizer = event.data.dig('event', 'organizer') || default_organizer
        location = event.data.dig('event', 'location') || default_location
        rrule = event.data.dig('event', 'rrule')
        tags = event.data['tags']
        exdate = event.data.dig('event', 'exdate')

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
        if rrule
          ical_event.rrule = rrule
            if exdate
              exdates = exdate.split(',').map do |d|
                date_obj = Date.parse(d.strip)
                Icalendar::Values::Date.new(date_obj)
              end
              ical_event.exdate = exdates
            end
        end

        ical_event.uid = file_path_to_uid(event.path)
        ical_event.summary = title
        ical_event.description = description
        ical_event.organizer = organizer
        ical_event.location = location

        cals[:events].add_event(ical_event)
        if tags
          tags.each do |tag|
            if cals.key?(tag)
              cals[tag].add_event(ical_event)
            else
              newCal = Icalendar::Calendar.new
              newCal.add_event(ical_event)
              cals[tag] = newCal
            end
          end
        end
      end

      cals.each_key { |tag|
        cal = cals[tag]
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

        site.pages << IcalPage.new(site, site.source, 'feed/eo-events/', "#{tag}.ics", cal)
        puts "Generated #{tag}.ics page from #{events.length} events"
      }
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
