class HomeController < ApplicationController
    def index
    end
  
    def about
    end
  
    def contact
    end
  
    def privacy
    end
    
    def search
        redirect_back(fallback_location: home_path) if params[:query].blank?

  end