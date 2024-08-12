# To deliver this notification:
#
# UserValidationNotification.with(post: @post).deliver_later(current_user)
# UserValidationNotification.with(post: @post).deliver(current_user)

class NoticeUpdateNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :action_cable
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :user_name
  param :notice_id

  # Define helper methods to make rendering easier.
  #
  def message
    t('notifications.messages.update_validation',
      user_name: params[:user_name],
      notice: params[:notice_id])
  end

  def url
    notice_path(params[:notice_id], nid: record.id)
  end
end
