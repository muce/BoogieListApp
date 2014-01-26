class HomeController < ActionController::Base
  layout 'application'
  
  def index
    puts 'INDEX'
    puts 'OAUTH: '+session[:oauth].to_s
    if 
      session[:access_token].blank? 
      puts 'ACCESS TOKEN: empty'
    else
      puts 'ACCESS TOKEN: '+session[:access_token]
    end
    if params[:code]
      puts 'CODE: '+params[:code]
    end
   	session[:oauth] = Koala::Facebook::OAuth.new(Facebook::CONFIG['app_id'], Facebook::CONFIG['secret_key'], Facebook::CONFIG['callback_url'] + '/home/callback')
		@auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 	
    puts "AUTH URL: "+@auth_url
  	# respond_to do |format|
		# 	 format.html {  }
		# end
		redirect_to(@auth_url)
  end

	def callback
  	if params[:code]
  		# acknowledge code and get access token from FB
		  session[:access_token] = session[:oauth].get_access_token(params[:code])
		end	

    # auth established, now do a graph call
		@api = Koala::Facebook::API.new(session[:access_token])
		@feed_limit = 25
		begin
			@posts = params[:page] ? @api.get_page(params[:page]) : @api.get_connections(Facebook::CONFIG['boogie_tunes_id'], "feed")
		  @user = @api.get_object("me")
		  check_user(@user)
		rescue Exception=>ex
			puts ex.message
		end
		
 		respond_to do |format|
		 format.html {   }
		end
	end
	
	def check_user(u)
	   if User.exists?(facebook_id: u['id'])
	     puts "found user "+u['name']
	   else
	     puts "didn't find user"
	     user = User.new(name: u['name'], facebook_id: u['id'])
	     if user.save
	       puts "created user "+user.name
	     end
	   end
	end
	
end

