class Bulletin < ApplicationRecord
  include AASM

  MAX_IMAGE_SIZE = 5.megabytes

  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title,  presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presence: true, content_type: %i[png jpg jpeg]
  validate :image_size


  aasm column: :state, skip_validation_on_save: true do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :to_moderate do
      transitions from: %i[draft rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end
  end

  scope :published, -> { where(state: :published) }
  scope :under_moderation, -> { where(state: :under_moderation) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title category_id state]
  end
  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end

  private

  def image_size
    return unless image.attached?
    return if image.blob.byte_size <= MAX_IMAGE_SIZE

    errors.add(:image, :too_large)
  end
end
