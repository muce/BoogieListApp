require 'uri'

class PostsController < ApplicationController
  before_action do
    set_nav_selected(1)
  end
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.paginate(:page => params[:page]).order(post_date: :asc)
    @user = session[:user]
    @playlists = Playlist.where(:user_id => @user.id)
    session[:current_playlist_id] = @playlists.first.id
    
    respond_to do |format|
      format.html {   }
    end
    
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_url, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  def set_current_playlist
    puts "SET PLAYLIST"
    puts post_params
  end
  
  def add_to_playlist
    # TODO: ensure uniqueness of post within playlist
    puts "ADD POST "+params[:id].to_s+" TO PLAYLIST "+session[:current_playlist_id].to_s
    @item = PlaylistPost.new(post_id: params[:id], playlist_id: session[:current_playlist_id])
    @item.save
    Resque.enqueue(EncoderWorker, params[:id])
    redirect_to posts_url
  end
  
  def remove_from_playlist
    puts "REMOVE "+params[:id]
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      # params.require(:post).permit(:facebook_id, :name, :artist, :title, :description, :link_url, :source_url, :message, :likes, :comments, :playlist)
    end
  
end
