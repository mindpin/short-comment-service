class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: String
  
  belongs_to :comment, :counter_cache => true
  belongs_to :post

  before_create :set_post_relative
  def set_post_relative
    self.post = self.comment.post
  end

  validate :check_user_vote
  def check_user_vote
    if self.comment.post.has_vote?(self.user_id)
      errors.add(:base, "user voted")
    end
  end
end
