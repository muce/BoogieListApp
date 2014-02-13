class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :playlists
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    puts "FIND FOR FACEBOOK OAUTH"
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      puts "USER FOUND "+user.to_s
      return user
    else
      puts "USER NOT FOUND FOR EMAIL "+auth.info.email.to_s
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        puts "REGISTERED USER "+registered_user.to_s
        return registered_user
      else
        puts "CREATE NEW USER"
        n = auth.extra.raw_info.name.to_s
        p = auth.provider.to_s
        u = auth.uid.to_s
        e = auth.info.email.blank? ? "unknown@unknown.com" : auth.info.email
        t = Devise.friendly_token[0, 20]
        puts "name: "+n+", provider: "+p+", uid: "+u+", email: "+e+", password: "+t
        user = User.create(name: n, provider: p, uid: u, email: e, password: t)
      end     
    end
  end
  
end
