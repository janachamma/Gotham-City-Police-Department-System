class CriminalsController < ApplicationController
  before_action :set_criminal, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource 
  
  def index
    @criminals = Criminal.all
    @enhanced_powers = Criminal.where(enhanced_powers: true)
    @suspects = Criminal.where(convicted_felon: false)
  end

  def new
    @criminal = Criminal.new
  end

  def create
  @criminal = Criminal.new(criminal_params)
    
    if @criminal.save
      flash[:notice] = "Successfully added #{@criminal.first_name} #{@criminal.last_name} to GCPD."
      redirect_to criminal_path(@criminal)
    else
      render :new
    end
  end
  

  def show
    @suspects = Criminal.where(convicted_felon: false)

  end

  def edit
  end

  def update
    updated = @criminal.update(criminal_params)
    message = updated ? 'Criminal was successfully updated.' : 'Update failed.'
    flash[updated ? :notice : :alert] = message
    updated ? redirect_to(@criminal) : render(:edit)
  end
  
  def destroy
    name = "#{@criminal.first_name} #{@criminal.last_name}"
    if @criminal.destroy
      flash[:notice] = "Removed #{name} from the system."
      redirect_to criminals_path
    end
  end
  

  private

  def set_criminal
    @criminal = Criminal.find(params[:id])
  end

  # Only allow a list of trusted parameters through
  def criminal_params
    params.require(:criminal).permit(:first_name, :last_name, :aka, :convicted_felon, :enhanced_powers)
  end
end