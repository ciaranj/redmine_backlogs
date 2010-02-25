include ItemsHelper

class BacklogsController < ApplicationController
  unloadable
  before_filter :find_backlog, :only => [:show, :update]
  before_filter :find_project, :authorize

  protect_from_forgery :only => []

  def index
    @items         = Item.find_by_project_except_tracker(@project, cookies[:subtask_tracker])
    @item_template = Item.new
    @backlogs      = Backlog.find_by_project(@project)
    @hide_closed_backlogs = (cookies[:hide_closed_backlogs] == "true")
    @hide_tasks = (cookies[:hide_tasks] == "true")
    render :view => "index", :layout => "backlogs_plugin"
  end

  def show
    # render :json => @backlog.to_json(:methods => [:description, :end_date, :eta, :name]) 
    render :view => "show", :layout => "backlogs_plugin"
  end
  
  def update
    @backlog = Backlog.update params
    render :json => @backlog.to_json(:methods => [:description, :end_date, :eta, :name]) 
  end

  private
  
  def find_project
    @project = if !params[:project_id].nil?
                 Project.find(params[:project_id])
               else
                 Backlog.find(params[:id]).version.project
               end
  end
  
  def find_backlog
    @backlog = if params[:id]=='0' || params[:id].nil?
                 nil
               else
                 Backlog.find(params[:id])
               end
  end
end
