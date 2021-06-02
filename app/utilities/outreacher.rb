class Outreacher

  # ideally these rules would be codified better -- with an engine that lets users create rules more granularly
  # and store them in the DB -- especially for query and retrieval by other piece of the application
  # but for a first-pass as part of a proof-of-concept with intent to iterate, this is probably okay

  def self.determine_engagement(weather: "", temp: "")
    raise ArgumentError.new("expected weather to have a non-blank value") if weather.blank?
    raise ArgumentError.new("expected temperature to have a non-blank value") if temp.blank?
    temp = temp.to_f  # let's make sure this is a number, even if that number turns out to be zero

    # Cool and Rainy Engagements
    return "Phone Call" if is_rainy?(weather.downcase) || temp < 55

    # Warm and Sunny Engagements
    return "Email" if  is_sunny?(weather.downcase) && temp > 75

    # Pleasant Engagements
    return "Text Message" if temp > 55 && temp < 75

    # Warm and not sunny Engagements
    return "Push Notification" if !(is_sunny?(weather.downcase)) && temp > 75

    # Default -- Just In Case
    return "Email"
  end

  def self.is_sunny?(str)
    return true if str.include? "clear"
    # possibly also include "few clouds" depending on our definition of "sunny"
    return false
  end

  def self.is_rainy?(str)
    return true if str.include? "rain"
    return true if str.include? "drizzle"
    return true if str.include? "storm"
    return false
  end

end
