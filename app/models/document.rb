class Document < ApplicationRecord
  audited

  has_many_attached :files
end
