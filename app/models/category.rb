class Category < ApplicationRecord
  has_many :bulletins, inverse_of: :category, dependent: :restrict_with_error
  validates :name, presence: true
end
