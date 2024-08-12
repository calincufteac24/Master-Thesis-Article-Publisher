module Admin
  class AuditsController < Admin::ApplicationController
    def index
      @audits = Audited::Audit.order(created_at: :desc).limit(50).group_by { |audit| audit.created_at.to_date }
    end
  end
end
