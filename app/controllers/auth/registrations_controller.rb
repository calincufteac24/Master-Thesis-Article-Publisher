module Auth
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    def roles_templates
      role_template = params[:template]
      head(:no_content) and return unless User.roles.keys.include?(role_template)

      respond_to do |format|
        format.turbo_stream do
          render(
            turbo_stream: turbo_stream.update('signup_information',
                                              partial: "/devise/registrations/roles/#{role_template}",
                                              locals: { user: User.new })
          )
        end
      end
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
        :sign_up,
        keys: [
          :first_name, :last_name, :personal_id, :passport_id, :role, :accept_terms, :name, :avatar,
          { user_personal_information_attributes: %i[identity_type personal_series personal_number passport_number photo] },
          { user_organizations_attributes: [:job_title, organization_attributes: [:name, :fiscal_code, :reg_com, :address, :contract_number, :role]] }
        ]
      )
      devise_parameter_sanitizer.permit(
        :account_update,
        keys: [
          :first_name, :last_name, :personal_id, :passport_id, :role, :accept_terms, :name, :avatar,
          { user_personal_information_attributes: %i[identity_type personal_series personal_number passport_number photo] },
          { user_organizations_attributes: [:job_title, organization_attributes: [:name, :fiscal_code, :reg_com, :address, :contract_number, :role]] }
        ]
      )
    end
  end
end
