require "json"
require 'open-uri'

class OpenWeather

  class << self
    def url
      "http://api.openweathermap.org/data/2.5/forecast?q=minneapolis,us&units=imperial&APPID=09110e603c1d5c272f94f64305c09436"
    end

    def get_data
      # Straightforward
      # Pull weather content hourly -- cache it because it's not going to change much more often, and is more performant
      Rails.cache.fetch("current_weather_conditions", expires_in: 1.hour) do
        HTTParty.get(self.url)
      end
    end

    # the workhorse method of this class
    def current_weather_data
      response = self.get_data

      # next steps: error handling in case the call breaks outright and returns nothing / no error code / a socketerror
      return unless response.response.code == "200"

      data_points = JSON.parse(response.body)["list"]
      weather_hash = {}

      # loop through the data points and then add to a list of points for each individual day
      data_points.map { |data_point|
        forecast_time = DateTime.strptime(data_point["dt"].to_s,'%s').in_time_zone("Central Time (US & Canada)")
        forecast_date = forecast_time.strftime("%B %-e")
        weather_hash[forecast_date] = [] if weather_hash[forecast_date].blank?

        temperature = data_point["main"]["temp"]
        weather_text = data_point["weather"].first["description"]
        icon = data_point["weather"].first["icon"]

        weather_hash[forecast_date] << {temperature: temperature, weather: weather_text, icon: icon}
      }

      weather_hash.keys.each do |key|
        weather_hash[key] = daily_weather(weather_hash[key])
      end

      # sometimes the way that the forecast looks out, we end up with extra days' worth of content
      # I'd check with the PO to see if we only want to consider full days of weather data
      # but for now I'm going to focus on the first five soonest days we have data for, and ignore the bits of day 6 that might creep into the feed
      return engagement_data(weather_hash).first(5)
    end

    # this method was a lot more complicated at first, but I slimmed it down
    # sort the day's data points to find the high temperature, and then pick it as our data for determining engagement
    def daily_weather(data)
      sorted = data.sort{ |x,y| y[:temperature] <=>  x[:temperature] }
      return sorted.first
    end

    # call the Outreacher utility to check the business rules, then return a precompased hash we can use in our views/components
    def engagement_data(weather_hash)
      weather_hash.keys.map { |key|
        data = weather_hash[key]
        engagement = Outreacher.determine_engagement(weather: data[:weather], temp: data[:temperature])
        {date: key, temperature: data[:temperature], weather: data[:weather], icon: data[:icon], engagement: engagement}
      }
    end

  end

end
