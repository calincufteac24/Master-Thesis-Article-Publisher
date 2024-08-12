class UserValidationMailer < ApplicationMailer
  def user_validation_notification
    @params = params
    @recipient = params[:recipient]
    @user = User.find(params[:user_id])
    mail(to: @recipient.email, subject: 'Un nou utilizator s-a înregistrat')
  end
end
