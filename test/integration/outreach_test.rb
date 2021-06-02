require 'test_helper'

class OutreachTest < ActionDispatch::IntegrationTest

  test "outreach analyzer works" do
   warm_engagement = Outreacher.determine_engagement(weather:"Clear Skies", temp: "77")
   assert_equal("Email", warm_engagement)

   cool_engagement = Outreacher.determine_engagement(weather:"Clear Skies", temp: "35")
   assert_equal("Phone Call", cool_engagement)

   rainy_engagement = Outreacher.determine_engagement(weather:"Rain", temp: "76")
   assert_equal("Phone Call", rainy_engagement)

   pleasant_engagement = Outreacher.determine_engagement(weather:"Partly Cloudy", temp: "65")
   assert_equal("Text Message", pleasant_engagement)

   hot_cloudy_engagement = Outreacher.determine_engagement(weather:"Partly Cloudy", temp: "85")
   assert_equal("Push Notification", hot_cloudy_engagement)

  end

end
