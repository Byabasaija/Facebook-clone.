class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :picture_size
  has_many :posts
  has_many :comments
  has_many :likes

  has_many :friend_request_sent, class_name: 'Friendship', foreign_key: :sent_by_id, inverse_of: :sent_by, dependent: :destroy
  has_many :friend_request_recieved, class_name: 'Friendship', foreign_key: :sent_to_id, inverse_of: :sent_to, dependent: :destroy
  has_many :friends,-> { merge(Friendship.friends) }, through: :friend_request_sent, source: :sent_to
  has_many :pending_friends,-> { merge(Friendship.not_friends) }, through: :friend_request_sent, source: :sent_to
  has_many :received_friends,-> { merge(Friendship.not_friends) }, through: :friend_request_recieved, source: :sent_by

  has_many :notifications, dependent: :destroy

  def full_name
    "#{fname} #{lname}"
  end
  
 
  def friends_and_own_posts
    myfriends_posts = friends
    all_posts = []
    myfriends_posts.each do |f|
      f.posts.each do |p|
        all_posts << p
      end
    end
    posts.each do |p|
      all_posts << p
    end
    all_posts
  end


  private
    def picture_size
      errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
    end
end
