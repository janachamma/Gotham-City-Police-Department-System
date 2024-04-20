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
    @officers = @unit.officers.alphabetical.paginate(page:params[:page]).per_page(10)

  end

  # GET /units/:id/edit
  def edit
  end

  # PATCH/PUT /units/:id
  def update
    if @unit.update(unit_params)
      flash[:notice] = "Updated unit information"
      redirect_to @unit
    else
      render :edit
    end
  end

  
  

  def destroy
    if @unit.destroy
      redirect_to units_path, notice: "Removed #{@unit.name} from the system."
    else 
      render :index
    end
  end



  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:active, :name)
  end
end
