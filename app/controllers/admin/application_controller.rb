# All Administrate controllers inherit from this
module Admin
  class ApplicationController < ApplicationController
    before_action :authenticate_admin

    def show
      render 'admin/dashboard'
    end

    protected

    def authenticate_admin
      user_signed_in? && current_user.admin?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
