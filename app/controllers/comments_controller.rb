class CommentsController < ApplicationController

  # inherited as helper method by ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
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
      flash[:notice] = 'Your vote was counted.'
    else
      flash[:error] = 'You can vote <string>that</string> only once.'.html_safe
    end
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end