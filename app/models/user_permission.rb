class UserPermission < ApplicationRecord
  enum permission: %i[
    can_view_users
    can_delete_users
    can_validate_ad
    can_create_publishing
    can_update_publishing
    can_delete_publishing
    can_validate_external_users
    can_create_stage
    can_update_stage
    can_delete_stage
    can_create_add_type
    can_update_add_type
    can_delete_add_type
  ]

  belongs_to :user

  validates :permission, uniqueness: { scope: :user_id }
end
