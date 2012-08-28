require 'rest_client'
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
    if @ticket != nil
      @stringUrl = 'https://sso.rumba.pearsoncmg.com/sso/samlValidate?service=http://nameless-bayou-1430.herokuapp.com/addTask&ticket=' + @ticket
      puts @stringUrl
      
      response = RestClient.get 'https://sso.rumba.pearsoncmg.com/sso/samlValidate', {:params => {'service' => 'http://nameless-bayou-1430.herokuapp.com/addTask', 'ticket' => @ticket}}
      puts response.to_str

    end
    @task = Task.new
    @task.name = response.to_str
    @task.list_id = 1
    @task = @list.tasks.new(@task)
    @task.save
    redirect_to(list_tasks_url(@list))
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
