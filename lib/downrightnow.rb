#!/usr/bin/env ruby

# External runtime dependencies
require 'nokogiri'
require 'trollop'

# System libraries
require 'open-uri'
require 'time'

module DownRightNow
  VERSION = '0.2.0'

  def DownRightNow.version
    VERSION
  end

  class DownRightNow
    # The original document received and parsed.
    attr_reader :doc

    # List of services as an array of strings.
    attr_reader :services

    # List of statuses (coresponding to services) as an array of strings.
    attr_reader :statuses

    # List of updates (coresponding to services) as an array of time objects.
    attr_reader :last_updates

    # Overall last update as a time object.
    attr_reader :last_updated_all

    def initialize
      refresh
    end

    # Go fetch the status document.
    def refresh
      @doc = Nokogiri::HTML(open('http://www.downrightnow.com'))
      @services = @doc.css('h2.serviceIcon a').map { |x| x.content.sub(/ status/,'') }
      @statuses = @doc.css('span.status').map(&:content)
      @last_updates = @doc.css('p.lastDisruption span.timestamp').map(&:content).map { |x| Time.parse(x) }
      @last_updated_all = Time.parse(@doc.css('form#autoRefreshForm p.sprite span.timestamp')[0].content)
    end

    # [ (services, statuses, last_updates) ... ]
    def to_tuple
      services.zip statuses, last_updates
    end

    def any_outages?
      statuses.any? { |x| x != 'Up' }
    end

    # Return a human-friendly representation.
    def to_s(verbose=false)
      alignment1 = services.map(&:length).max + 2
      alignment2 = statuses.map(&:length).max + 2

      result = "%*s: %*s   " % [alignment1, "Service Name", -alignment2, "Status"]
      result += "   Last Update" if verbose
      result += "\n"

      result += "-"*(alignment1+alignment2+8+(verbose ? 25:0)) + "\n"
      
      to_tuple.each { |name, status, last_update|
	result += "%*s: %*s   " % [alignment1, name, -alignment2, status]
	result += "   #{last_update}" if verbose
	result += "\n"
      }
      result += "\nOverall last update was at: #{last_updated_all}\n"
      result
       
    end
  end # class DownRightNow
end # module DownRightNow
