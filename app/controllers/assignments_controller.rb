class AssignmentsController < ApplicationController
    before_action :set_officer, only: [:new, :create]
    before_action :set_assignment, only: [:destroy]
  
    def new
      @assignment = Assignment.new
      @officer = Officer.find(params[:officer_id])
      @officer_investigations = @officer.investigations

    end
  
    def create
      @assignment = @officer.assignments.build(assignment_params)
  
      if @assignment.save
        flash[:notice] = 'Successfully added assignment.'
        redirect_to officer_path(@assignment.officer)
      else
        render :new, locals: { officer: @officer }
      end
    end
  
    def destroy
      if @assignment.destroy
        flash[:notice] = 'Successfully terminated assignment.'
        redirect_to officer_path(@assignment.officer)
      else
        flash[:alert] = 'There was a problem terminating the assignment.'
        redirect_to officer_path(@assignment.officer)
      end
    end
  
    private
  
    def set_officer
      @officer = Officer.find(params[:officer_id])
    end
  
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end
  
    def assignment_params
      params.require(:assignment).permit(:officer_id, :investigation_id, :start_date, :end_date)
    end
  end
  