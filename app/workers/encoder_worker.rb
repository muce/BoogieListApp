class EncoderWorker
  @queue = :encode
  
  def self.perform(str)
    puts "EncoderWorker: "+str
  end
  
end