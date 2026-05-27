class User < ApplicationRecord
  has_many :bulletins, inverse_of: :user, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
