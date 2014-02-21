class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action do
    set_nav_selected(2)
  end

  # GET /playlists
  # GET /playlists.json
  def index
    # @playlists = session[:user].playlists.all
    @playlists = Playlist.all
    @items = []
    @playlists.each do |p|
      @items << p.posts
    end
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    @items = @playlist.posts
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.user_id = session[:user].id
    
    respond_to do |format|
      if @playlist.save
        format.html { redirect_to playlists_url, notice: 'Playlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to playlists_url, notice: 'Playlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url }
      format.json { head :no_content }
    end
  end


  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:user_id, :name)
    end
end
