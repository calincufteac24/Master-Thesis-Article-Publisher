class Notice < ApplicationRecord
  PRICE_PER_CHARACHTER = 0.05

  belongs_to :creator, class_name: 'User'
  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :ad_type
  belongs_to :ad_type_stage
  belongs_to :invoiceable, polymorphic: true, optional: true

  has_many :notice_values, dependent: :destroy
  has_many :ad_type_fields, through: :notice_values
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_rich_text :description

  audited

  enum status: %i[draft sent revised]

  accepts_nested_attributes_for :notice_values

  validates_associated :notice_values
  validates :ad_type_id, presence: true

  before_create :set_creation_dependencies
  before_save :calculate_price_if_needed
  after_create :send_validation_notification
  after_commit :refresh_active_notices, :refresh_search_notice

  scope :listable, -> { order(created_at: :desc) }

  scope :revised, -> { where(status: 'revised') }

  scope :unrevised, -> { where(status: ['draft', 'sent']) }

  store :options, accessors: %i[buy_electronic buy_hardcopy]

  scope :with_average_rating, -> {
    left_joins(:ratings)
      .select('notices.*, COALESCE(AVG(ratings.rating), 0) AS avg_rating')
      .group('notices.id')
      .order('avg_rating DESC NULLS LAST')
  }

  scope :order_by_fields_date, -> {
    joins('INNER JOIN views_notices_by_dates ON views_notices_by_dates.notice_id = notices.id')
    .order(Arel.sql("to_date(views_notices_by_dates.date_value, 'DD-MM-YYYY') DESC NULLS LAST"))
  }

  scope :search_by_terms, -> (search_terms) {
    joins('INNER JOIN views_search_notices ON views_search_notices.notice_id = notices.id')
      .where(
        search_terms.map do |term|
          sanitize_sql_array(['views_search_notices.title ILIKE :term OR views_search_notices.observation ILIKE :term OR views_search_notices.description ILIKE :term', term: "%#{term}%"])
        end.join(' OR ')
      ).select('DISTINCT notices.*')
  }

  def invoiceable_gid
    invoiceable&.to_global_id
  end

  def invoiceable_gid=(gid)
    self.invoiceable = GlobalID::Locator.locate gid
  end

  def calculate_price
    no_characters = notice_values.includes(:ad_type_field)
                                 .where.not(ad_type_field: { form_field_type: :file })
                                 .map { |value| "#{value.ad_type_field.text_before} #{value.value} #{value.ad_type_field.text_after}" }
                                 .join(' ')
                                 .length
    description_characters = description.body.to_plain_text.length

    self.price = ((no_characters + description_characters) * PRICE_PER_CHARACHTER).round(2)
  end

  def calculate_price_if_needed
    return unless self.creator # Ensure `creator` is present
    return if self.creator.admin?

    if self.class.user_notices_published_this_month(self.creator) >= 3
      calculate_price.round(2)
    else
      self.price = 0
    end
  end

  def self.user_notices_published_this_month(user)
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    where(creator: user, created_at: start_of_month..end_of_month).count
  end

  def average_rating
    if ratings.any?
      ratings.average(:rating).round(2)
    else
      0
    end
  end

  def refresh_active_notices
    Views::NoticesByDates.refresh
  end

  def refresh_search_notice
    Views::SearchNotice.refresh
  end

  private

  def send_validation_notification
    NoticeValidationNotification.with(notice_id: id, user_name: self.creator.name).deliver_later(User.where(admin: true))
  end

  def set_creation_dependencies
    self.status = :draft
  end
end
