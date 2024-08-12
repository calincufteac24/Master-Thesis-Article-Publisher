class Comment < ApplicationRecord
  belongs_to :notice
  belongs_to :user
  after_create :send_validation_notification

  private

  def noticed_users
    User.where(admin: true).or(User.where(id: notice.creator_id))
  end

  def send_validation_notification
    CommentValidationNotification.with(notice_id: self.notice_id, user_name: self.user.name).deliver_later(noticed_users)
  end
end
