class ErrorsController < ApplicationController
  
  skip_before_filter :login_required
  
  def render_404     
   respond_to do |format| 
     format.html { 
       render :file => "#{Rails.root}/public/404.html", 
       :status => :missing
       flash[:error] = "This page doesn't exist"
     }
     format.xml  { head :not_found, :status => :missing }
     format.json { head :not_found, :status => :missing }
    end
  end
end