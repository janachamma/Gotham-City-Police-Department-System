class OfficersController < ApplicationController
  before_action :set_officer, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @active_officers = Officer.where(active: true)
    @inactive_officers = Officer.where(active: false)
  end

  def new
    @officer = Officer.new
  end

  def create
      @officer = Officer.new(officer_params)
    
      if @officer.save
        flash[:notice] = "Successfully created Eric Blake."
        redirect_to officer_path(@officer)
      else
        Rails.logger.info(@officer.errors.full_messages.to_sentence) 
        flash[:error] = "Officer could not be created: " + @officer.errors.full_messages.to_sentence
        render :new
      end
    end

  # GET /officers/1
  def show
    @current_assignments = @officer.assignments.where(end_date: nil)
    @past_assignments = @officer.assignments.where.not(end_date: nil)
  end

  def edit
  end

  def update
    if @officer.update(officer_params)
      redirect_to officer_path(@officer), notice: 'Officer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @officer.assignments.exists?
      flash[:alert] = "Officer has current assignments and cannot be deleted."
      render :show
    else
      proper_name = @officer.proper_name 
      @officer.destroy
      redirect_to officers_path, notice: "Removed #{proper_name} from the system."
    end
  end

  private

  def set_officer
    @officer = Officer.find(params[:id])
  end

  def officer_params
    params.require(:officer).permit(:active, :ssn, :rank, :first_name, :last_name, :unit_id, :username, :role, :password, :password_confirmation)
  end
end