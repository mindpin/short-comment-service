class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  
  has_many :comments, :order => :votes_count.desc
  has_many :votes

  def self.get(url)
    Post.find_or_create_by(url: url)
  end

  def has_comment?(user_id)
    self.comments.where(:user_id => user_id).exists?
  end

  def comment_content_of(user_id)
    return "" if !has_comment?(user_id)
    self.comments.where(:user_id => user_id).first.content
  end

  def has_vote?(user_id)
    self.votes.where(:user_id => user_id).exists?
  end

  def vote_comment_of(user_id)
    return nil if !has_vote?(user_id)
    self.votes.where(:user_id => user_id).first.comment
  end
end
