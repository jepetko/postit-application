class CommentsController < ApplicationController

  # inherited as helper method by ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = Comment.new(comment_params.merge(post: @post, creator: current_user))

    if @comment.save
      flash[:notice] = 'Your comment was added'
      redirect_to post_path(@post)
    else
      # no post_path because this would be an url
      # we need a template
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
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
        hash = { count: @comment.total_votes }
        hash[:notice] = notice if notice
        hash[:error] = error if error
        render json: hash
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end