class Relationship < ApplicationRecord
  
  #フォローテーブルではなく、Userモデルからフォローフォロワーを探しにいく必要がある。
  belongs_to :follower, class_name: "User"
  belongs_to :followerd, class_name: "User"
  
end
