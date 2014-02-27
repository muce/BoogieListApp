require 'taglib'

class EncodeJob < Struct.new(:user, :post)
  
  def perform
    i = post.link_url.to_s
    d = Rails.root.join('public', 'audio').to_s
    f = "/"+post.facebook_id+".%(ext)s"
    o = d+f
    `youtube-dl -o "#{o}" -x --audio-format mp3 #{i}`
    # `youtube-dl -x --audio-format mp3 #{i}`
  end

  def before(job)
    puts 'JOB START'
  end
  
  def success(job)
    puts 'JOB SUCCESS'
    
    d = Rails.root.join('public', 'audio').to_s
    f = post.facebook_id+".mp3"
    o = d+"/"+f
    
    TagLib::FileRef.open(o) do |fileref|
      if fileref.null?
        puts "TAGLIB BAD MP3 URL"
      else
        tag = fileref.tag
        tag.title = post.title
        tag.artist = post.artist
        tag.comment = post.description
        fileref.save
        puts 'COMPLETED TAGGING'
        # properties = fileref.audio_properties
        # properties.length  #=> 335 (song length in seconds)
      end
    end

    f = post.facebook_id+".mp3"
    post.mp3_url = f
    post.save
    
    puts 'COMPLETED SAVE'
    
  end
  
  def error(job, exception)
    puts 'JOB EXCEPTION '+exception.to_s
  end
  
  def failure(job)
    puts 'JOB FAIL - DO SOMETHING'
  end
  
end
