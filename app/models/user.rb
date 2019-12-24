class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_one_attached :picture
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
   format: { with: VALID_EMAIL_REGEX },
   uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def already_liked?(micropost)
    self.likes.exists?(micropost_id: micropost.id)
  end

  def resize_picture
    return self.picture.variant(resize: '200x200').processed
  end

  class << self

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end


    def new_token
      SecureRandom.urlsafe_base64
    end
  end

   def create_reset_digest
     self.reset_token = User.new_token
     update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
   end

   def send_password_reset_email
     UserMailer.password_reset(self).deliver_now
   end



   def remember
     self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
   end

   #remember_tokenがremember_digestと一致するか確認
   def authenticated?(attribute, token)
     digest = send("#{attribute}_digest")
     return false if digest.nil?
     BCrypt::Password.new(digest).is_password?(token)
   end

   #remember_digestカラムを空に更新
   def forget
     update_attribute(:remember_digest, nil)
   end

   def activate
     update_attribute(:activated, true)
   end

   def send_activation_email
     UserMailer.account_activation(self).deliver_now
   end

   def password_reset_expired?
     reset_sent_at < 2.hours.ago
   end


  private

    def downcase_email
      email.downcase!
    end

    def create_activation_digest
     self.activation_token  = User.new_token
     self.activation_digest = User.digest(activation_token)
    end


end
