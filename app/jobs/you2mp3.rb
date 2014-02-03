module You2mp3
  @queue = :food
  
  def self.perform(class_name, id)
    puts "working: class_name=#{class_name} id=#{id}"
    System(`/usr/local/bin/youtube-dl -o "314642735316936_529577387156802.%(ext)s" -x --audio-format "mp3" http://www.youtube.com/watch?v=3Naggh94ReQ`)
  end
  
end