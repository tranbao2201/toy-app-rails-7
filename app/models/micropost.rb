class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachment|
    attachment.variant :display, resize_to_limit: [500, 500]
  end
  scope :by_user_ids, -> ids { where(user_id: ids) }

  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
    message: "must be a valid image format" },
    size:         { less_than: 5.megabytes,
    message:   "should be less than 5MB" }
end
