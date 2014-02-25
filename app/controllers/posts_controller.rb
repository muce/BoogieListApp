require 'xmpp4r_facebook'

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
    if session[:current_playlist_id].blank?
      if @playlists.size > 0
        session[:current_playlist_id] = @playlists.first.id
      else
        session[:current_playlist_id] = 1
      end
    end
    if !@playlists.blank?
      @playlist = Playlist.find(session[:current_playlist_id])  
      @items = @playlist.posts
    end
    
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
  
  def set_playlist
    session[:current_playlist_id] = params[:playlist][:id] if !params[:playlist].blank?
    redirect_to posts_url
  end
  
  def add_to_playlist
    puts "ADD TO PLAYLIST"
    puts "ID "+params[:id].to_s
    puts "CURRENT PLAYLIST ID "+session[:current_playlist_id].to_s
    if !Playlist.find(session[:current_playlist_id]).posts.exists?(params[:id])
      puts "ADDING TO PLAYLIST"
      @item = PlaylistPost.new(post_id: params[:id], playlist_id: session[:current_playlist_id])
      @item.save
      post = Post.find(params[:id])
      rip_audio(post)
      # send_email(post)
      # send_fb_message(post)
    end
    redirect_to posts_url
  end
  
  def remove_from_playlist
    puts "REMOVE FROM PLAYLIST"
    @item = PlaylistPost.find_by(post_id: params[:id], playlist_id: session[:current_playlist_id])
    @item.destroy
    redirect_to posts_url
  end
  
  def rip_audio(post)
    puts "RIP AUDIO "+post.to_s
    if post.mp3_url.blank?
      puts "CREATE DJ"
      Delayed::Job.enqueue EncodeJob.new(session[:user], post), :queue => 'user_'+session[:user].uid
    else
      puts "ALREADY ENCODED"
    end
  end
  
  def send_email(post)
    # Resque.enqueue(EncoderWorker, params[:id])
    UserMailer.send_mail(session[:user].name).deliver
  end

  def send_fb_message(post)
    puts "SEND FB MESSAGE"
    sender_chat_id = "-100007673834464@chat.facebook.com"
    receiver_chat_id = "-538006773@chat.facebook.com"
    message_body = "test message"
    message_subject = "test subject"
    
    jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
    jabber_message.subject = message_subject
    
    puts "sender_chat_id "+sender_chat_id
    puts "receiver_chat_id "+receiver_chat_id
    
    # TODO: Use ENV for app_id and secret_key
    client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
    client.connect
    client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
                     Facebook::CONFIG['app_id'], 
                     session[:access_token],
                     Facebook::CONFIG['secret_key']), nil)
    client.send(jabber_message)
    client.close
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      # params.require(:post).permit(:facebook_id, :name, :artist, :title, :description, :link_url, :source_url, :message, :likes, :comments, :playlist)
    end
  
end
