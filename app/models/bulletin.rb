class Bulletin < ApplicationRecord
  MAX_IMAGE_SIZE = 5.megabytes

  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title,  presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presences: true
  validate :image_size

  private

  def image_size
    return unless image.attached?
    return if image.blob.byte_size <= MAX_IMAGE_SIZE

    errors.add(:image, :too_large)
  end
end
