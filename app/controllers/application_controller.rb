class ApplicationController < ActionController::Base
  include Pagy::Backend
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :read_current_notification!
  # before_action :masquerade_user!
  protected

  def read_current_notification!
    return if params[:nid].nil?

    notification = Notification.find_by(id: params[:nid])

    return if notification.nil? || notification.read?
    notification.mark_as_read!
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
