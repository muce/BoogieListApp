class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    puts "OMNIAUTH CALLBACK FACEBOOK"
    puts "AUTH HASH BEGIN"
    request.env['omniauth.auth'].each do |k,v|
      puts k.to_s+":    "+v.to_s
    end
    puts "AUTH HASH END"
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    session[:user] = @user
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    puts "ACCESS TOKEN "+session[:access_token]
    if @user.persisted?
      puts "USER PERSISTED"
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      # redirect_to posts_url
    else
      puts "USER NOT PERSISTED"
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to posts_url
    end
  end
end