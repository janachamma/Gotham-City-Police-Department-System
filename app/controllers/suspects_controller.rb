class SuspectsController < ApplicationController
    # before_action :set_investigation, only: [:new, :create,]
    before_action :set_suspect, only: [:terminate]
    before_action :check_login
    authorize_resource
    # GET /investigations/:investigation_id/suspects/new
    def new
      @suspect = Suspect.new
      @investigation = Investigation.find(params[:investigation_id])
      @current_suspects = @investigation.suspects

      # other setup code may be needed to prepare the new suspect
    end
  
    # POST /suspects
    def create
      @suspect = Suspect.new(suspect_params)
      if @suspect.save
        flash[:notice] = "Successfully added suspect."
        redirect_to investigation_path(@suspect.investigation)
      else
        render :new
      end
    end
  
    # PATCH/PUT /suspects/:id/terminate
    def terminate
      if @suspect.update(dropped_on: Date.current)
        redirect_to investigation_path(@suspect.investigation), notice: 'Suspect was successfully terminated.'
      else
        render :edit 
      end
    end
  
    private
  
    # def set_investigation
    #   @investigation = Investigation.find(params[:investigation_id])
    # end
  
    def set_suspect
      @suspect = Suspect.find(params[:id])
    end
  
    def suspect_params
      params.require(:suspect).permit(:criminal_id, :investigation_id, :added_on)
    end
  end
  