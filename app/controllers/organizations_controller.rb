class OrganizationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[find]

  def find
    respond_to do |format|
      format.turbo_stream do
        @organization = OpenApi::Organization.find(find_params[:q])
        if @organization.present?
          @organization.role = find_params[:role]

          render(
            turbo_stream: turbo_stream.update('company_form',
                                              partial: '/devise/registrations/templates/organization_form',
                                              locals: { organization: @organization, user: User.new })
          )
        else
          head :no_content
        end
      end
    end
  end

  private

  def find_params
    params.permit(:q, :role)
  end
end
