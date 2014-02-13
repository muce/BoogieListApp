class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy]
  before_action do
    set_nav_selected(4)
  end
  
  # GET /imports
  # GET /imports.json
  def index
    @imports = Import.all
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
  end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # GET /imports/1/edit
  def edit
  end

  # POST /imports
  # POST /imports.json
  def create
    @import = Import.new(import_params)

    respond_to do |format|
      if @import.save
        format.html { redirect_to imports_path, notice: 'Import was successfully created.' }
        format.json { render action: 'show', status: :created, location: @import }
      else
        format.html { render action: 'new' }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    puts "IMPORT DESTROY "+@import.id
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url }
      format.json { head :no_content }
    end
  end
  
  def run
    puts "IMPORT RUN "+params[:id]
    import = Import.find(params[:id])
    group_id = '314642735316936'
    # query = Facebook::CONFIG['boogie_tunes_id']+"/feed?limit="+import.limit.to_s+"&until="+import.until+"&__paging_token="+Facebook::CONFIG['boogie_tunes_id']+"_"+import.paging_token+"&access_token="+session[:access_token]
    query = "feed"
    if !import.limit.blank?
      query += "?limit="+import.limit.to_s
    end
    if !import.until.blank?
      query += "&until="+import.until
    end
    if !import.paging_token.blank?
      query += "&__paging_token="+group_id+"_"+import.paging_token
    end
    puts "QUERY "+query
    begin
      api = Koala::Facebook::API.new(session[:access_token])
      posts = params[:page] ? api.get_page(params[:page]) : api.get_connections(group_id, query)
    rescue Exception=>ex
      puts ex.message
      puts "ERROR!!!!!"
      redirect_to('/500.html')
      return
    end
    if !posts.blank?
      puts "POSTS RETURN OK"
      puts "POSTS COUNT "+posts.size.to_s
      posts.each do |p|
        import_post(p)
      end
      import.update(completed: true)
      add_next(posts.next_page_params)
      redirect_to imports_path
      return
    else
      puts "POSTS RETURN NOT OK"
      redirect_to('/500.html')
      return
    end
    
  end
  
  def import_post(post)
    if !Post.find_by facebook_id: post['id']
      if is_youtube_post(post)
        puts post['likes'].to_s
        p = Post.new(picture_url: post['picture'], 
                     facebook_id: post['id'], 
                     name: post['name'], 
                     description: post['description'], 
                     link_url: post['link'], 
                     source_url: post['source'], 
                     message: post['message'], 
                     post_date: post['created_time'], 
                     likes: post['likes'], 
                     comments: post['comments'])
        if p.link_url.blank?
          p.link_url = strip_youtube_url(post['message'])
        end
        ary = create_artist_and_title(post['name'])
        p.artist = ary.first
        p.title = ary.last
        p.save
      end
    end
  end
  
  def add_next(params)
    puts "ADD NEXT PARAMS "+params.to_s
    data = params[1]
    l = data['limit']
    u = data['until']
    t = data['__paging_token'].split('_')[1]
    import = Import.new(limit: l, until: u, paging_token: t)
    import.save
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
  
  # Return first youtube URL from input string
  def strip_youtube_url(str)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.require(:import).permit(:limit, :until, :paging_token)
    end
    
end
