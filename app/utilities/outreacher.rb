class Outreacher

  def self.determine_engagement(weather: "", temp: "")
    raise ArgumentError.new("expected weather to have a non-blank value") if weather.blank?
    raise ArgumentError.new("expected temperature to have a non-blank value") if temp.blank?
    temp = temp.to_f  # let's make sure this is a number, even if that number turns out to be zero

    # Cool and Rainy Engagements
    return "Phone Call" if weather.downcase.include?("rain") || temp < 55

    # Warm and Sunny Engagements
    return "Email" if weather.downcase.include?("clear") && temp > 75

    # Pleasant Engagements
    return "Text Message" if temp > 55 && temp < 75

    # Default / Really Warm but not Sunny Engagements
    return "??"
  end

end
