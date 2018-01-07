class ActivitiesController < ApplicationController
  
  def index
    @activities = Activity.by_position
  end

  def sort
    params[:order].each do |key, value|
      Activity.find(value[:id]).update(position: value[:position])
    end

    render nothing: true
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

  def destroy
    @activity = Activity.find(params[:id])

    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
    end
  end
  private
  
  def activity_params
    params.require(:activity).permit(:title)
  end

end
