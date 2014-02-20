Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :google_oauth2, ENV["316807536298.apps.googleusercontent.com"], ENV["lMeo6PvI3SrOt4gxq2moj5hO"]
  provider :facebook, ENV["618163964915398"], ENV["4bc5887fe63bf61fb0df310e02de6698"]
  
end