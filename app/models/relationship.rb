class Relationship < ApplicationRecord
  
  #belongs_to :followerと書くと、followersテーブルを探しにいくのでエラーになる。Userモデルを探しにいく必要がある。
  belongs_to :follower, class_name: "User"
  belongs_to :followerd, class_name: "User"
  
end
