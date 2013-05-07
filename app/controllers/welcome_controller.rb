class WelcomeController < ApplicationController

  def index
    if signed_in?
      redirect_to day_path('today')
    end
  end

end
