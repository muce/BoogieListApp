class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
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

  def google_oauth2
      @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
      
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end
end