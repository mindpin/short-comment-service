class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,    type: String
  field :content,    type: String
  field :votes_count, type: Integer, default: 0

  belongs_to :post
  
  has_many :votes

  validates :user_id, uniqueness: {scope: :post_id}
end
