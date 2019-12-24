class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  default_scope { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :memo, length: { maximum: 255 }
  validates :only_user_id, presence: true
  validate :validate_picture


  def resize_picture
    return self.picture.variant(resize: '200x200').processed
  end

private
   def only_user_id
     memo.presence or picture.attached?
   end

   def validate_picture
     if picture.attached?
       # if !picture.contant_type.in?(%('image/jpeg image/jpg image/gif'))
       #   errors.add(:picture, 'はjpeg, jpg, gif以外の投稿ができません')
       if picture.blob.byte_size > 5.megabytes
         errors.add(:picture, "のサイズが5MBを超えています")
       end
     end
   end
end

  # def image?
  #   %w[image/jpg image/jpeg image/gif image/png].include?(picture.blob.content_type)
  # end
