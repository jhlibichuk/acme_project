class ApplicationController < ActionController::Base
  before_action :set_location

  # default location
  # for other users/use cases we'd query our user data or data about where we're targeting
  # maybe even from the UI
  # for now though...
  
  def set_location
    @location = "Minneapolis, MN"
  end

end
