Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :google_oauth2, '316807536298.apps.googleusercontent.com', 'lMeo6PvI3SrOt4gxq2moj5hO'
  # provider :facebook, '618163964915398', '4bc5887fe63bf61fb0df310e02de6698'
  
end