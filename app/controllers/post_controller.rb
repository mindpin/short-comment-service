class PostController < ApplicationController
  layout false
  before_filter :check_user, :only => [:comments, :votes]
  def check_user
    if current_user_id.blank?
      render :nothing => true, :status => 401
    end
  end
  before_filter :set_access_control_headers
  def set_access_control_headers
    response.headers['Access-Control-Allow-Origin']   = request.headers["Origin"]
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end

  def index
    render :nothing => true
  end

  def show
    response.headers.delete('X-Frame-Options')
    user_id = get_or_create_user_id

    @post = Post.get(params[:url])
  end

  def comments
    user_id = current_user_id
    @post = Post.get(params[:url])
    if @post.has_comment?(user_id)
      return render :nothing => true, :status => 403
    end

    @post.comments.create(:user_id => user_id, :content => params[:comment])
    render :nothing => true
  end

  def votes
    user_id = current_user_id
    @post = Post.get(params[:url])
    if @post.has_vote?(user_id)
      return render :nothing => true, :status => 403
    end
    @comment = @post.comments.where(:id => params[:comment_id]).first
    if @comment.blank?
      return render :nothing => true, :status => 422
    end
    @comment.votes.create(:user_id => user_id)
    render :nothing => true
  end

end
