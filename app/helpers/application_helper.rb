module ApplicationHelper
  include Pagy::Frontend
  def user_notices_published_this_month(user)
    return 0 if user.admin?
    current_month_start = Date.today.beginning_of_month
    user.created_notices.where('created_at >= ?', current_month_start).count
  end

  def user_avatar(user = nil, **options)
    user ||= current_user
    return unless user

    if user.avatar.attached?
      height = options[:height].presence || 30
      width = options[:width].presence || 30
      css_class = options[:class].presence || 'rounded-circle img-responsive mt-2'
      image_tag user.avatar.variant(resize: "#{width}x#{height}"), class: css_class, width: width, height: height
    else
      Initials.svg(user.name, colors: 12, size: options[:size].presence || 20)
    end
  end
end
