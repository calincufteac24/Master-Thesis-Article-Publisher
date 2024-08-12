# To deliver this notification:
#
# UserValidationNotification.with(post: @post).deliver_later(current_user)
# UserValidationNotification.with(post: @post).deliver(current_user)

class UserValidationNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :action_cable
  deliver_by :email, mailer: 'UserValidationMailer', if: :unread?
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :user_id
  param :user_name
  param :user_role

  # Define helper methods to make rendering easier.
  #
  def message
    t('notifications.messages.user_validation',
      user_name: params[:user_name],
      user_role: t("users.roles.#{params[:user_role]}"))
  end

  def url
    user_path(params[:user_id], nid: record.id)
  end
end
