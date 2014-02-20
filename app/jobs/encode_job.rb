class EncodeJob < Struct.new(:user, :post)

  def enqueue(job)
    puts 'encode_job/enqueue'
  end
  
  def print
    i = post.link_url.to_s
    d = Rails.root.join('public', 'audio').to_s
    f = "/"+post.facebook_id+".mp3"
    o = d+f
    puts 'youtube-dl -o '+o+' -x --audio-format mp3 -k '+i
  end
  
  def perform
    puts "EncodeJob perform user: "+user.to_s+", post: "+post.to_s
    i = post.link_url.to_s
    d = Rails.root.join('public', 'audio').to_s
    f = "/"+post.facebook_id+".mp3"
    o = d+f
    `youtube-dl -o #{o} -x --audio-format mp3 #{i}`
  end

  def before(job)
    puts 'encode_job/start'
  end
  
  def after(job)
    puts 'encode_job/after'
  end
  
  def success(job)
    puts 'encode_job/success'
  end
  
  def error(job, exception)
    puts 'encode_job/exception '+exception.to_s
  end
  
  def failure(job)
    puts 'encode_job/failure'
  end
  
end
