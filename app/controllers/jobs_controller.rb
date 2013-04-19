class JobsController < ApplicationController
  skip_before_filter :login_required
  before_filter :contrib_required, :only => :destroy
  
  PER_PAGE = 10
    
  # Uses pagination Gem to only display 10 entries per page.  
  # GET /jobs
  # GET /jobs.xml
  # GET /jobs.json
  def index
    per_page = params[:per_page] ||= PER_PAGE
    @jobs = Job.paginate :page => params[:page],
                          :per_page => params[:per_page],
                          :order=>'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  {render :xml => @jobs} 
      format.json {render :json => @jobs}
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  # GET /jobs/1,json
  def show
    begin
      @job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { 
            redirect_to("#{jobs_path}?page=1")
            flash[:error] = "Couldn't find the Job to show."
          }
          format.xml  { head :not_found, :status => :missing }
          format.json { head :not_found, :status => :missing }
        end
    else
      @current_page = params[:page] ||= 1
      respond_to do |format|
        format.html # show.html.erb
        format.xml  {render :xml => @job} 
        format.json {render :json => @job}
      end
    end
  end
  
  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  # DELETE /jobs/1.json
  def destroy
    begin
      @job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { 
            redirect_to("#{jobs_path}?page=1")
            flash[:error] = "Couldn't find the Job to destroy."
          }
          format.xml  { head :not_found, :status => :missing }
          format.json { head :not_found, :status => :missing }
        end
    else
      if is_author_or_editor?(@job.broadcast)
        @job.destroy

        current_page = params[:page] ||= 1
      
        respond_to do |format|
          # TODO: At some point do a check to see if there are no items left on the current
          # page and if so and page > 1, then decrement current page by 1
          format.html { redirect_to(jobs_path(:page=>current_page) ) }
          format.xml  { head :ok }
          format.json { {:success => 'true'} }
        end
      else
        denied("You cannot delete this broadcast")
      end
    end
  end

  def feed
    # this will be the name of the feed displayed on the feed reader
    @title = "CSA Jobs Feed"

    # the news items
    @jobs = Job.order("updated_at desc")

    # this will be our Feed's update timestamp
    @updated = @jobs.first.updated_at unless @jobs.empty?

    respond_to do |format|
      format.atom { render :layout => false }
      format.rss { render :layout => false }
    end
  end
end
