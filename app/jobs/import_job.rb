class ImportJob < Struct.new(:import)
  
  def enqueue(job)
    puts 'import_job/enqueue'
  end
  
  def perform
    puts "import_job/perform  "+user.to_s+", post: "+post.to_s
    
  end

  def before(job)
    puts 'import_job/start'
  end
  
  def after(job)
    puts 'import_job/after'
  end
  
  def success(job)
    puts 'import_job/success'
  end
  
  def error(job, exception)
    puts 'import_job/exception '+exception.to_s
  end
  
  def failure(job)
    puts 'import_job/failure'
  end
  
end
