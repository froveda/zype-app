class ApplicationController < ActionController::Base
  include WardenHelper

  protect_from_forgery with: :exception
  before_filter :store_current_location

  private
  def store_current_location
    session[:store_location] = request.url
  end

  def stored_location
    session[:store_location]
  end
end
