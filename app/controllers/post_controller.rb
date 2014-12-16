class PostController < ApplicationController
  layout false
  before_filter :check_user, :only => [:comments, :votes]
  def check_user
    if _get_user_id.blank?
      render :nothing => true, :status => 401
    end
  end

  def index
    render :nothing => true
  end

  def show
    user_id = _get_or_create_user_id

    @post = Post.get(params[:url])
  end

  def comments
    user_id = _get_user_id
    @post = Post.get(params[:url])
    if @post.has_comment?(user_id)
      render :nothing => true, :status => 403
    end

    @post.comments.create(:user_id => user_id, :content => params[:comment])
    render :nothing => true
  end

  def votes
    user_id = _get_user_id
    @post = Post.get(params[:url])
    if @post.has_vote?(user_id)
      render :nothing => true, :status => 403
    end
    @comment = @post.comments.where(:id => params[:comment_id]).first
    if @comment.blank?
      render :nothing => true, :status => 422
    end
    @comment.votes.create(:user_id => user_id)
    render :nothing => true
  end

  def _get_or_create_user_id
    user_id = _get_user_id
    if user_id.blank?
      user_id = randstr
      cookies.permanent.signed["user_id"] = user_id
    end
    return user_id
  end

  def _get_user_id
    cookies.signed["user_id"]
  end
end
