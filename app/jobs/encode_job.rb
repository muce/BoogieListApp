class EncodeJob < Struct.new(:user, :post)
  
  def enqueue(job)
    puts 'encode_job/enqueue'
  end
  
  def perform
    i = post.link_url.to_s
    d = Rails.root.join('public', 'audio').to_s
    f = "/"+post.facebook_id+".%(ext)s"
    o = d+f
    `youtube-dl -o "#{o}" -x --audio-format mp3 #{i}`
    # `youtube-dl -x --audio-format mp3 #{i}`
  end

  def before(job)
    puts 'encode_job/start'
  end
  
  def after(job)
    puts 'encode_job/after'
  end
  
  def success(job)
    puts 'encode_job/success'
    
    d = Rails.root.join('public', 'audio').to_s
    f = post.facebook_id+".mp3"
    o = d+"/"+f

    f = post.facebook_id+".mp3"
    post.mp3_url = f
    post.save
    
    puts 'COMPLETED TAGGING'
    
  end
  
  def error(job, exception)
    puts 'encode_job/exception '+exception.to_s
  end
  
  def failure(job)
    puts 'encode_job/failure'
  end
  
end
