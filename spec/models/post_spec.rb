require 'rails_helper'

RSpec.describe Post, :type => :model do
  it {
    url = "http://test.com/test"
    expect(Post.count).to eq(0)
    post = Post.get(url)
    expect(Post.count).to eq(1)
    expect(post.new_record?).to eq(false)
    expect(post.url).to eq("http://test.com/test")
    post = Post.get(url)
    expect(Post.count).to eq(1)
  }

  it{
    url = "http://test.com/test"
    post = Post.get(url)
    expect(Post.count).to eq(1)

    comment = post.comments.create(:user_id => "xxx1", :content => "感人")
    expect(Comment.count).to eq(1)    
    expect(comment.votes_count).to eq(0)    
    comment.votes.create(:user_id => "xxx2")
    expect(comment.votes_count).to eq(1)    
  }

  it{
    url = "http://test.com/test"
    post = Post.get(url)
    expect(Post.count).to eq(1)

    comment1 = post.comments.create(:user_id => "xxx1", :content => "感人1")
    comment2 = post.comments.create(:user_id => "xxx2", :content => "感人2")

    comment1.votes.create(:user_id => "xxx3")

    expect(post.comments.map{|c|c.content}).to eq(["感人1", "感人2"])
    comment2.votes.create(:user_id => "xxx4")
    comment2.votes.create(:user_id => "xxx5")

    comment2.votes.create(:user_id => "xxx7")    
    comment1.votes.create(:user_id => "xxx6")    

    post = Post.get(url)
    expect(post.comments.map{|c|c.content}).to eq(["感人2", "感人1"])
  }

  it{
    url = "http://test.com/test"
    post = Post.get(url)
    expect(Post.count).to eq(1)
    user_id = "xxx1"

    expect(post.has_comment?(user_id)).to eq(false)

    comment1 = post.comments.create(:user_id => user_id, :content => "感人1")
    comment2 = post.comments.create(:user_id => user_id, :content => "感人2")

    expect(comment1.new_record?).to eq(false)
    expect(comment2.new_record?).to eq(true)

    expect(post.has_comment?(user_id)).to eq(true)
    expect(post.comment_content_of(user_id)).to eq("感人1")
  }


  it{
    url = "http://test.com/test"
    post = Post.get(url)
    expect(Post.count).to eq(1)
    user_id = "xxx1"

    comment1 = post.comments.create(:user_id => "xxxy", :content => "感人1")
    comment2 = post.comments.create(:user_id => "xxxz", :content => "感人2")

    expect(post.has_vote?(user_id)).to eq(false)
    comment1.votes.create(:user_id => user_id)
    expect(Vote.count).to eq(1)
    comment2.votes.create(:user_id => user_id)
    expect(Vote.count).to eq(1)
    expect(post.has_vote?(user_id)).to eq(true)

    expect(post.vote_comment_of(user_id)).to eq(comment1)
  }
end
