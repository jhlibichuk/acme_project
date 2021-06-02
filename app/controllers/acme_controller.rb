class AcmeController < ApplicationController

  def index
    @location = "Minneapolis, MN"
    @days = OpenWeather.current_weather_data
    @now = Time.now

  end

end
