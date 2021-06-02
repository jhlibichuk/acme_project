require 'test_helper'

class HomepageTest < ActionDispatch::IntegrationTest

  test "homepage loads" do
    get "/"
    assert_response :success
  end

end
