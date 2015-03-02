class PostsController < ApplicationController
  def index
    @posts = Post.all
    respond_to do |format|
      format.html { render 'index' }
      format.json { render :json => @posts.to_json }
    end
  end

  def show
    @post = Post.find(params[:id])
  end
end
