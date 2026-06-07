class User < ApplicationRecord
  has_many :bulletins, inverse_of: :user, dependent: :destroy

  before_validation :normalize_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
