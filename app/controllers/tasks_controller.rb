require 'net/http'
class TasksController < ApplicationController


  def index
    @todo   = Task.where(:done => false)
    @task   = Task.new
    @lists  = List.all
    @list   = List.new
    
    respond_to do |format|
      format.html
    end
  end


  def create
    @list = List.find(params[:list_id])
    @task = @list.tasks.new(params[:task])
    if @task.save
        flash[:notice] = "Your task was created."
    else
        flash[:alert] = "There was an error creating your task."
    end
    redirect_to(list_tasks_url(@list))
  end
    
   def create_sms
    @list = List.find(1)
    @ticket = params[:ticket]
    url = URI.parse('https://sso.rumba.pearsoncmg.com/sso/login?service=http://nameless-bayou-1430.herokuapp.com/addTask&ticket=' + @ticket)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    @task = @list.tasks.new(:new => res.body)
    if @task.save
        render :content_type  => "text/xml", :text => "<Response><Sms>Thanks for the memories</Sms></Response>"
    else
        render :content_type  => "text/xml", :text => "<Response><Sms>FUCK THIS SHIT</Sms></Response>"
    end 
  end
  

  def update
    @list = List.find(params[:list_id])
    @task = @list.tasks.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to( list_tasks_url(@list), :notice => 'Task was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(list_tasks_url(@list)) }
    end
  end
  
 
end
