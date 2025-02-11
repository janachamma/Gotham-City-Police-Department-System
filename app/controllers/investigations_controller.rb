class InvestigationsController < ApplicationController
    before_action :set_investigation, only: [:show, :edit, :update, :close]
    before_action :check_login
    authorize_resource 
    
    # GET /investigations
    def index
        @open_investigations = Investigation.is_open
        @closed_investigations = Investigation.is_closed
        @closed_unsolved = Investigation.is_closed.unsolved
        @with_batman = Investigation.with_batman
        @unassigned_cases = Investigation.unassigned
    end
  
    # GET /investigations/new-
    def new
      @investigation = Investigation.new
    end
  
    # POST /investigations
    def create
      @investigation = Investigation.new(investigation_params)
      if @investigation.save
        flash[:notice] = "Successfully added '#{investigation_params[:title]}' to GCPD."
        redirect_to @investigation
      else
        render :new
      end
    end
  
    # GET /investigations/:id
    def show
  @investigation = Investigation.find(params[:id])
  @current_assignments = @investigation.assignments.current.chronological
  @current_officers= @current_assignments.map{|o| o.officer}
  @current_suspects = @investigation.suspects.current.alphabetical 
end

  
  
    def edit
    end
  
    # PATCH/PUT /investigations/:id
    def update
      if @investigation.update(investigation_params)
        flash[:notice] = "Investigation updated successfully."
        redirect_to @investigation
      else
        render :edit
      end
    end
  
    # DELETE /investigations/:id
    # def destroy
    #   if @investigation.destroy
    #     flash[:notice] = "Investigation has been closed."
    #     redirect_to investigations_path
    #   else
    #     flash[:alert] = "Investigation could not be removed."
    #     redirect_to @investigation
    #   end
    # end
  
    
    def close
        if @investigation.update(date_closed: Date.current, solved: true) # Assuming closing an investigation also marks it as solved
          flash[:notice] = 'Investigation has been closed.'
          redirect_to investigations_path
        end
      end
    
    private
  
    def set_investigation
      @investigation = Investigation.find(params[:id])
    end
  
    def investigation_params
      params.require(:investigation).permit(:title, :description, :crime_location, :date_opened)
    end

    
  end