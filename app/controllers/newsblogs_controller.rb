class NewsblogsController < ApplicationController
  skip_before_filter :login_required
  before_filter :contrib_required, :only => :destroy

  PER_PAGE = 10

  # GET /newsblogs
  # GET /newsblogs.xml
  def index
    per_page = params[:per_page] ||= PER_PAGE
    @newsblogs = Newsblog.paginate :page => params[:page],
                          :per_page => params[:per_page],
                          :order=>'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @newsblogs} # index.xml.builder
      format.json {render :json => @newsblogs}
    end
  end

  # GET /newsblogs/1
  # GET /newsblogs/1.xml
  def show
    begin
      @newsblog = Newsblog.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { 
            redirect_to("#{newsblogs_path}?page=1")
            flash[:error] = "Couldn't find the News entry to show."
          }
          format.xml  { head :not_found, :status => :missing }
          format.json { head :not_found, :status => :missing }
        end
    else  
      @current_page = params[:page] ||= 1
        
      respond_to do |format|
        format.html # show.html.erb
        format.xml {render :xml => @newsblog}# show.xml.builder
        format.json {render :json => @newsblog}
      end
    end
  end
  
  def destroy
    begin
      @newsblog = Newsblog.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { 
          redirect_to("#{newsblogs_path}?page=1")
          flash[:error] = "Couldn't find the News to destroy."
        }
        format.xml  { head :not_found, :status => :missing }
        format.json { head :not_found, :status => :missing }
      end
    else
      if is_author_or_editor?(@newsblog.broadcast)
        @newsblog.destroy
    
        current_page = params[:page] ||= 1

        respond_to do |format|
          # TODO: At some point do a check to see if there are no items left on the current
          # page and if so and page > 1, then decrement current page by 1
          format.html { redirect_to(newsblogs_path(:page=>current_page) ) }
          format.xml  { head :ok }
        end
      else
        denied("You cannot delete this broadcast")
      end
    end
  end
  
  def feed
    # this will be the name of the feed displayed on the feed reader
    @title = "CSA News Feed"

    # the news items
    @newsblogs = Newsblog.order("updated_at desc")

    # this will be our Feed's update timestamp
    @updated = @newsblogs.first.updated_at unless @newsblogs.empty?

    respond_to do |format|
      format.atom { render :layout => false }
      format.rss { render :layout => false }
    end
  end
  
end
