class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookcomments, dependent: :destroy
  
  # まずは中間テーブルを作りフォローをした、されたの関係を定義 クラス名はテーブル名　外部キーはカラム名と一致させる
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followerd_id", dependent: :destroy
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followerd
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # xxxはアソシエーションが繋がっているテーブル名、class_nameは実際のモデルの名前、foreign_keyは外部キーとして何を持つかを表しています。
  #has_many :xxx, class_name: "モデル名", foreign_key: "○○_id", dependent: :destroy
  #「has_many :テーブル名, through: :中間テーブル名」 の形を使って、テーブル同士が中間テーブルを通じてつながっていることを表現します。(followerテーブルとfollowedテーブルのつながりを表す）
  # 例えば、yyyにfollowedを入れてしまうと、followedテーブルから中間テーブルを通ってfollowerテーブルにアクセスすることができなくなってしまいます。
  #  これを防ぐためにyyyには架空のテーブル名を、zzzは実際にデータを取得しにいくテーブル名を書きます。
  #has_many :yyy, through: :xxx, source: :zzz
  #この結果、@user.yyyとすることでそのユーザーがフォローしている人orフォローされている人の一覧を表示することができるようになります。

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #フォローする時 モデルにdefを定義するときはコントローラーに書くのを省略するため
  def follow(user_id)
    relationships.create(followerd_id: user_id)
  end
  #フォロー解除する時　user_idはだれがみてもuserのidとbookのidを区別するため　findbyメソッドは外部キーを使ってなにか指定するとき
  #findメソッドは主キーからさがすとき。ちなみに自分のキー以外が外部キー。
  def unfollow(user_id)
    relationships.find_by(followerd_id: user_id).destroy
  end
  #フォローしているかの定義　idが不要なのはparamsとかcurrentでわかるから　一人の関係なので、上記は二人の関係
  def following?(user) 
    followings.include?(user)
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end
