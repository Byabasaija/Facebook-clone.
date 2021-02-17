class PostsController < ApplicationController
  def index
    @all_posts = current_user.friends_and_own_posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(posts_params)
      if @post.save
        flash[:notice]="Post created"
        redirect_to @post
      else
        flash[:alert]="Something went wron while creating post"
        render 'new'
      end
  end

  def destroy
    
  end

  private
  def posts_params
   params.require(:post).permit(:content, :imageURL)
  end
end
