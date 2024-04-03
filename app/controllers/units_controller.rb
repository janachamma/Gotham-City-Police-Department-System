class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  # GET /units
  def index
    @active_units = Unit.where(active: true)
    @inactive_units = Unit.where(active: false)
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      flash[:notice] = "Successfully added #{unit_params[:name]} to GCPD."
      redirect_to units_path
    else
      render :new
    end
  end

  # GET /units/:id
  def show
    @officers = @unit.officers

  end

  # GET /units/:id/edit
  def edit
  end

  # PATCH/PUT /units/:id
  def update
    if @unit.update(unit_params)
      redirect_to @unit
    else
      render :edit
    end
  end

  # def destroy
  #   if @unit.officers.empty?
  #     unit_name = @unit.name
  #     @unit.destroy
  #     flash[:notice] = "Removed #{unit_name} from the system."
  #     redirect_to units_path
  #   else
  #     flash[:alert] = "Unit cannot be removed because there are officers still assigned."
  #     redirect_to units_path
  #   end
  # end
  def destroy
    if can_destroy_unit?
      unit_name = @unit.name
      @unit.destroy
      flash[:notice] = "Removed #{unit_name} from the system."
      redirect_to units_path
    else
      flash[:alert] = "Unit cannot be removed because there are officers still assigned."
      redirect_to @unit
    end
  end
  # def destroy
  #   unit_name = @unit.name # Capture the name before destroying
  #   if @unit.destroy
  #     flash[:notice] = "Removed #{unit_name} from the system."
  #     redirect_to units_path
  #   else
  #     # If there's a condition that could prevent destruction, handle it here
  #     flash[:alert] = "Unit could not be removed."
  #     redirect_to @unit
  #   # 
  # endend

  def destroy
    if @unit.officers.exists?
      flash[:alert] = "Cannot remove a unit that has officers assigned to it."
      render :index
    else
      @unit.destroy
      flash[:notice] = "Removed Major Crimes from the system."
      redirect_to units_path
    end
  end



  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:active, :name)
  end
  def can_destroy_unit?
    @unit.officers.empty?
  end
end
