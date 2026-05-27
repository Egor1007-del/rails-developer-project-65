class Bulletin < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title,  presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
end
