
 class CrimesController < ApplicationController
     before_action :set_crime, only: [:edit, :update]
      before_action :check_login
      authorize_resource
  
        # GET /crimes
        def index
          @active_crimes = Crime.where(active: true)
          @inactive_crimes = Crime.where(active: false)
        end
  
        # GET /crimes/new
        def new
          @crime = Crime.new
        end
  
        # GET /crimes/1/edit
        def edit
        end
  
        # POST /crimes
        def create
          @crime = Crime.new(crime_params)
          
          if @crime.save
            flash[:notice] = "Successfully added Bribery to GCPD."
            redirect_to crimes_path
          else
            render :new
          end
        end
      
       
        # PATCH/PUT /crimes/1
        def update
          if @crime.update(crime_params)
            flash[:notice] = "Crime was successfully updated."
            redirect_to crimes_path
          else
            render :edit
          end
        end
        # DELETE /crimes/1
        # def destroy
        #   @crime.destroy
        #   head :no_content
        # end
        private
      
        def set_crime
          @crime = Crime.find(params[:id])
        end
      
        def crime_params
          params.require(:crime).permit(:name, :active)
        end
  
       
          # Only allow a list of trusted parameters through.
          # def crime_params
          #   params.require(:crime).permit(:name, :felony, :active)
          # end
 end