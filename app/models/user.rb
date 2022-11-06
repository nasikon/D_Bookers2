class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookcomments, dependent: :destroy
  
  # まずはフォローをした、されたの関係を定義 クラス名はテーブル名　外部キーはカラム名と一致させる
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followerd_id", dependent: :destroy
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followerd
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #フォローする時
  def follow(usr_id)
    relationships.create(folllowerd_id: user_id)
  end
  #フォロー解除する時
  def unfollow(user_id)
    relationships.find_by(folllowerd_id: user_id).destroy
  end
  #フォローしているかの定義
  def following?(user) 
    followings.include?(user)
  end

end
