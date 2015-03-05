class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = User.first

    if @comment.save
      flash[:notice] = 'Your comment was added'
      redirect_to post_path(@post)
    else
      # no post_path because this would be an url
      # we need a template
      render 'posts/show'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

end