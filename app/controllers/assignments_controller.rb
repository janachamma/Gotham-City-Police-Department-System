class AssignmentsController < ApplicationController
    # before_action :set_officer, only: [:new, :create]
    before_action :set_assignment, only: [:terminate]
 before_action :check_login
    authorize_resource
  
    def new
      @assignment = Assignment.new
      @officer = Officer.find(params[:officer_id])
      @officer_investigations = @officer.investigations

    end
  
    def create
      @assignment = Assignment.new(assignment_params)  
      @assignment.start_date = Date.current
      if @assignment.save
        flash[:notice] = 'Successfully added assignment.'
        redirect_to officer_path(@assignment.officer)
      else
        @officer = Officer.find(params[:assignment][:officer_id])
        render :new, locals: { officer: @officer }
      end
    end
  
def terminate
  @assignment = Assignment.find(params[:id])

  @assignment.update(end_date: Date.current) # assuming end_date signifies the termination of an assignment
    redirect_to officer_path(@assignment.officer), notice: 'Successfully terminated assignment.'
  # else
  #   redirect_to officer_path(@assignment.officer), alert: 'Unable to terminate assignment.'
  # end
end

    private
  
    # def set_officer
    #   @officer = Officer.find(params[:officer_id])
    # end
  
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end
  
    def assignment_params
      params.require(:assignment).permit(:officer_id, :investigation_id, :start_date, :end_date)
    end
  end
  