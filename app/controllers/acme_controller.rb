class AcmeController < ApplicationController

  def index
    # returns an array of day/weather data hashes which looks like this:
    # [{date: string, temperature: float, weather: string, icon: string, engagement: string},{}...]

    @days = OpenWeather.current_weather_data

    # I'm okay calling this on pageload because it's cached...
    # but I'd also consider grabbing data in a background job, then storing that data
    # and then querying the DB to get the results intead
    # which I think would be more reliable long-term

  end

end
