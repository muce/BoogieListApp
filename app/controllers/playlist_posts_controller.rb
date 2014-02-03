class PlaylistPostsController < ApplicationController
  before_action :set_playlist_post, only: [:show, :edit, :update, :destroy]

  # GET /playlist_posts
  # GET /playlist_posts.json
  def index
    @playlist_posts = PlaylistPost.all
  end

  # GET /playlist_posts/1
  # GET /playlist_posts/1.json
  def show
  end

  # GET /playlist_posts/new
  def new
    @playlist_post = PlaylistPost.new
  end

  # GET /playlist_posts/1/edit
  def edit
  end

  # POST /playlist_posts
  # POST /playlist_posts.json
  def create
    @playlist_post = PlaylistPost.new(playlist_post_params)

    respond_to do |format|
      if @playlist_post.save
        format.html { redirect_to @playlist_post, notice: 'Playlist post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist_post }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlist_posts/1
  # PATCH/PUT /playlist_posts/1.json
  def update
    respond_to do |format|
      if @playlist_post.update(playlist_post_params)
        format.html { redirect_to @playlist_post, notice: 'Playlist post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_posts/1
  # DELETE /playlist_posts/1.json
  def destroy
    @playlist_post.destroy
    respond_to do |format|
      format.html { redirect_to playlist_posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist_post
      @playlist_post = PlaylistPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_post_params
      params.require(:playlist_post).permit(:playlist_id, :post_id)
    end
end
