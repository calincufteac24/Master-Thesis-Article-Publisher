module Auth
  class InvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters

    def new
      self.resource = resource_class.new
      resource.role = :person_extern
      render :new
    end

    protected

    def respond_with_navigational(resource)
      respond_with resource
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite, keys: %i[email role first_name last_name])
      devise_parameter_sanitizer.permit(
        :accept_invitation,
        keys: [
          :first_name, :last_name, :personal_id, :passport_id, :role, :accept_terms,
          { user_personal_information_attributes: %i[identity_type personal_series personal_number passport_number photo] },
          { user_organizations_attributes: [:job_title, organization_attributes: [:name, :fiscal_code, :reg_com, :address, :contract_number, :role]] }
        ]
      )
    end
  end
end
