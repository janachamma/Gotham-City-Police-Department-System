class InvestigationNotesController < ApplicationController
    before_action :set_investigation, only: [:new, :create]
    load_and_authorize_resource :investigation_note, through: :investigation, shallow: true
  
    def new
      @investigation_note = @investigation.investigation_notes.new
      @investigation = Investigation.find(params[:investigation_id])

    end
  
    def create
      @investigation_note = @investigation.investigation_notes.new(investigation_note_params)
      if @investigation_note.save
        flash[:notice] = 'Successfully added investigation note.'
        redirect_to @investigation_note.investigation
      else
        render :new
      end
    end
  
    private
  
    def set_investigation
      @investigation = Investigation.find(params[:investigation_id])
    end
  
    def investigation_note_params
      params.require(:investigation_note).permit(:content, :officer_id, :investigation_id)
   
    end
end
