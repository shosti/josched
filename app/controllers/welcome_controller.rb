class WelcomeController < ApplicationController

  def index
    redirect_to day_path('today') if signed_in?
  end

end
