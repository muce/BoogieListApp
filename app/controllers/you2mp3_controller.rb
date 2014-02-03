class You2mp3Controller < ApplicationController
  
  def food
    Resque.enqueue(You2mp3, params[:food])
    render :text => "Resque.enqueue(You2mp3, params["+params[:food].to_s+"])"
  end
  
end
