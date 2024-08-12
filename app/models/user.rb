class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable, :omniauthable, omniauth_providers: [:google_oauth2]

  audited

  attr_accessor :accept_terms

  has_one_attached :avatar
  has_person_name

  has_many :notifications, as: :recipient, dependent: :destroy

  has_one :user_personal_information, dependent: :destroy

  has_many :user_organizations, dependent: :destroy
  has_many :organizations, through: :user_organizations
  has_many :user_permissions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy

  has_many :created_notices, dependent: :nullify, class_name: 'Notice', foreign_key: :creator_id, inverse_of: :creator
  has_many :assinged_notices, dependent: :nullify, class_name: 'Notice', foreign_key: :assigned_to_id, inverse_of: :assigned_to

  enum role: %i[person_extern company_extern employee colaborator]
  enum status: %i[pending_approval approved]

  PUBLIC_ROLES = %i[person_extern company_extern employee colaborator].freeze

  validates :email, :first_name, :last_name, :role, presence: true
  validates :accept_terms, presence: true, on: :create
  validates_associated :user_personal_information, :organizations


  scope :with_permission, lambda { |permission|
    left_outer_joins(:user_permissions).where(admin: true).or(where(user_permissions: { permission: permission })).distinct
  }

  accepts_nested_attributes_for :user_personal_information, :user_organizations

  before_create :approve_user!, unless: :needs_validation?
  after_create :send_validation_notification, if: :needs_validation?

  def permission?(permission)
    admin? || user_permissions.exists?(permission: permission)
  end

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize do |u|
      u.email = auth.info.email
      u.password = Devise.friendly_token[0, 20]
      u.avatar_url = auth.info.image
      u.provider = 'Google'

      u.first_name, u.last_name = auth.info.name.split(" ", 2)
      u.role = :person_extern
      u.accept_terms = true
      u.skip_confirmation!
    end

    if user.new_record?
      user.user_permissions.build(permission: :can_validate_ad)
      if user.save
        puts "Utilizatorul a fost creat cu success"
      else
        puts "Errors: #{user.errors.full_messages.join(', ')}"
      end
    else
      puts "Utilizatorul există deja"
    end

    user
  end

  def active_for_authentication?
    super && approved?
  end

  def rated_notice?(notice)
    ratings.exists?(notice: notice)
  end

  def rating_for_notice(notice)
    ratings.find_by(notice: notice)
  end

  private

  def send_validation_notification
    UserValidationNotification.with(user_id: id, user_name: name, user_role: role).deliver_later(User.with_permission(:can_validate_external_users))
  end

  def needs_validation?
    employee? || person_extern? || company_extern?
  end

  def approve_user!
    self.status = 'approved'
  end
end
