class CrimeInvestigationsController < ApplicationController
    # before_action :set_investigation, only: [:create, :destroy]
    before_action :set_crime_investigation, only: [:destroy]
    before_action :check_login
      authorize_resource
  
    def new
      
        @investigation = Investigation.find(params[:investigation_id])
    
        @crime_investigation = CrimeInvestigation.new
    
        @crimes_list = @investigation.crimes
      end
    
  
    # POST /investigations/:investigation_id/crime_investigations
    def create
      # @investigation = Investigation.find(params[:investigation_id])

      @crime_investigation = CrimeInvestigation.new(crime_investigation_params)
      if @crime_investigation.save
        flash[:notice] = "Successfully added #{@crime_investigation.crime.name} to #{@crime_investigation.investigation.title}."
        redirect_to investigation_path(@crime_investigation.investigation)
      else
        @crimes_list = Crime.all # Re-populate crimes_list for the form
        render :new
      end
    end
  
   # DELETE /crime_investigations/:id
def destroy

    # @crime_investigation = CrimeInvestigation.find(params[:id])
    # investigation = crime_investigation.investigationS 

    @crime_investigation.destroy
    # if crime_investigation.destroy
      flash[:notice] = "Successfully removed a crime from this investigation."
      redirect_to investigation_path(@crime_investigation.investigation)
    # else
      
      # flash[:notice] = "There was a problem removing the crime from the investigation."
      # redirect_to investigation_crimes_path(investigation)
    # end
  end
  
    private
  
    def set_crime_investigation
      @crime_investigation = CrimeInvestigation.find(params[:id])
    end
  
  
    def crime_investigation_params
      params.require(:crime_investigation).permit(:crime_id, :investigation_id)
    end
  end
