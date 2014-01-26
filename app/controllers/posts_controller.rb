require 'uri'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    
    # auth established, now do a graph call
    @api = Koala::Facebook::API.new(session[:access_token])
    @feed_limit = 25
    begin
      @fbposts = params[:page] ? @api.get_page(params[:page]) : @api.get_connections(Facebook::CONFIG['boogie_tunes_id'], "feed")
      import_from_fb
    rescue Exception=>ex
      puts ex.message
    end
    
    respond_to do |format|
     format.html {   }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
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
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
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
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:facebook_id, :name, :artist, :title, :description, :link_url, :source_url, :message, :likes, :comments)
    end
      
    def import_from_fb
      # TODO: Ensure post has a youtube url 
      @fbposts.each do |post|
        if !Post.find_by facebook_id: post['id']
          if is_youtube_post(post)
            p = Post.new(picture_url: post['picture'], facebook_id: post['id'], name: post['name'], description: post['description'], link_url: post['link'], source_url: post['source'], message: post['message'])
            if p.link_url.blank?
              p.link_url = strip_youtube_urls(post['message'])
            end
            ary = create_artist_and_title(post['name'])
            p.artist = ary.first
            p.title = ary.last
            p.save
          end
        end
      end
    end
    
    # Test for existence of youtube url in source, link, message
    def is_youtube_post(p)
      ok = false
      if !p['source'].blank? && p['source'].include?('youtube')
        ok = true
      end
      if !p['link'].blank? && p['link'].include?('youtube')
        ok = true
      end
      if !p['message'].blank? && p['message'].include?('youtube')
        ok = true
      end
      return ok
    end
    
    def strip_youtube_urls(str)
      uris = ['http', 'https']
      urls = []
      if !str.blank?
        str.scan(URI.regexp(uris)) do |*matches|
          urls << $&
        end
      end
      if urls.any?
        return urls.first
      else
        return ""
      end
    end
    
    # Attempt to split name into artist and title fields
    def create_artist_and_title(str)
      fields = ["", ""]
      if !str.blank?
        if str.include?('-')
          fields = str.split('-', 2)
        end
      end
      return fields
    end
  
end
