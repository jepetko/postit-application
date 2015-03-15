class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action only: [:update, :edit] do
    require_edit_role(@post)
  end
  # 1. set up instance variable for action
  # 2. redirect based on some condition

  def index
    @posts = Post.all.sort_by { |post| post.total_votes }.reverse
    respond_to do |format|
      format.html { render 'index' }
      format.json { render :json => @posts.to_json }
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      flash[:notice] = 'Your post was created.'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'The post has been updated'
      redirect_to posts_path
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    if @vote.valid?
      notice = 'Your vote was counted.'
    else
      error = 'You can only vote for that once.'
    end
    respond_to do |format|
      format.html do
        flash[:notice] = notice if notice
        flash[:error] = error if error
        redirect_to :back
      end
      format.json do
        hash = { count: @post.total_votes }
        hash[:notice] = notice if notice
        hash[:error] = error if error
        render json: hash
      end
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :description, :category_ids => [])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end
end
