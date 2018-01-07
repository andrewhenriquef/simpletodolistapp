class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

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
  end
  
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to activities_path, notice: 'Your activity was updadated.' }
      else
        format.html { render :edit }
      end
    end
  end
  
  def show
  end

  def destroy

    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
    end
  end
  private
  
  def activity_params
    params.require(:activity).permit(:title)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end

end
