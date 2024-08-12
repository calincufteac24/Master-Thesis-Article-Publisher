class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def terms
  end

  def privacy
  end
end
