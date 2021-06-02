require "json"
require 'open-uri'

class OpenWeather

  class << self
    def url
      "http://api.openweathermap.org/data/2.5/forecast?q=minneapolis,us&units=imperial&APPID=09110e603c1d5c272f94f64305c09436"
    end

    def get_data
      # Pull weather content hourly
      Rails.cache.fetch("current_weather_conditions", expires_in: 1.hour) do
        HTTParty.get(self.url)
      end
    end

    def current_weather_data
      response = self.get_data
      return unless response.response.code == "200"

      data_points = JSON.parse(response.body)["list"]
      weather_hash = {}

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
      return engagement_data(weather_hash)
    end

    def daily_weather(data)
      sorted = data.sort{ |x,y| y[:temperature] <=>  x[:temperature] }
      return sorted.first
    end

    def engagement_data(weather_hash)
      weather_hash.keys.map { |key|
        data = weather_hash[key]
        engagement = Outreacher.determine_engagement(weather: data[:weather], temp: data[:temperature])
        {date: key, temperature: data[:temperature], weather: data[:weather], icon: data[:icon], engagement: engagement}
      }
    end

  end

end
