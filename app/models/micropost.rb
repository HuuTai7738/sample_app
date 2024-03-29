class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  scope :all_post, ->(user){where user_id: user.following_ids << user.id}
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.content_max_length}
  validates :image, content_type: {in: Settings.image_types,
                                   message: :msg_invalid_image},
                    size: {less_than: Settings.max_image_size.megabytes,
                           message: :msg_invalid_size}
  def display_image
    image.variant resize_to_limit: [Settings.image_size, Settings.image_size]
  end
end
