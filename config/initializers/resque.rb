ENV["REDISTOGO_URL"] ||= "redis://redistogo:b53f76b6d127e6222b6e551c786f7123@jack.redistogo.com:9990/"
uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
Dir[File.join(Rails.root, 'app', 'jobs', '*.rb')].each { |file| require file }