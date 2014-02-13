class HomeController < ActionController::Base
  layout 'application'
  
  def index
    
  end
  
  def login
    if params[:code]
      redirect_to(posts_url)
    else
   	  session[:oauth] = Koala::Facebook::OAuth.new(Facebook::CONFIG['app_id'], Facebook::CONFIG['secret_key'], Facebook::CONFIG['callback_url'] + '/home/callback')
		  @auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 	
		  redirect_to(@auth_url)
		end
  end

	def callback
  	if params[:code]
		  session[:access_token] = session[:oauth].get_access_token(params[:code])
		end	

    # auth established, now do a graph call to retrieve FB user and store in session
		begin
		  @api = Koala::Facebook::API.new(session[:access_token])
			session[:user] = check_user(@api.get_object("me"))
		rescue Exception=>ex
			puts ex.message
		end
		
 		redirect_to(posts_url)
 		
	end
	
  # Lookup FB user and add to DB if non existent
  def check_user(u)
     if User.exists?(facebook_id: u['id'])
       user = User.find_by facebook_id: u['id']
       puts "found user "+user.name
     else
       user = User.new(name: u['name'], facebook_id: u['id'])
       user.save
       puts "created user "+user.name
     end
     return user
  end
	
end

