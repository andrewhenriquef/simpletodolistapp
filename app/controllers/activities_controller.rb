class ActivitiesController < ApplicationController
  
  def index
    @activities = Activity.all
  end

  def new 
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    
    respond_to do |format|
      if @activity.save
        format.html { redirect_to activities_path, notice: 'Your activity is now live.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @activity = Activity.find(params[:id])
  end
  
  def update
    @activity = Activity.find(params[:id])
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to activities_path, notice: 'Your activity was updadated.' }
      else
        format.html { render :edit }
      end
    end
  end
  
  def show
    @activity = Activity.find(params[:id])
  end

  private
  
  def activity_params
    params.require(:activity).permit(:title)
  end

end
