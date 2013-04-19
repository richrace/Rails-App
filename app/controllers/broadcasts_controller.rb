class BroadcastsController < ApplicationController
  # This is an admin specific controller, so enforce access by admin only
  # This is a very simple form of authorisation
  before_filter :contrib_required

   # Default number of entries per page
  PER_PAGE = 10
 
  # GET /broadcasts
  # GET /broadcasts.xml
  def index
    per_page = params[:per_page] ||= PER_PAGE
    @broadcasts = Broadcast.paginate :page => params[:page],
                                     :per_page => params[:per_page],
                                     :order=>'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @broadcasts }
      format.json { render :json => @broadcasts }
    end
  end

  # GET /broadcasts/1
  # GET /broadcasts/1.xml
  def show
    begin
      @broadcast = Broadcast.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { 
            redirect_to("#{broadcasts_path}?page=1")
            flash[:error] = "Couldn't find the Broadcast to show."
          }
          format.xml  { head :not_found, :status => :missing }
          format.json { head :not_found, :status => :missing }
        end
    else
      @current_page = params[:page] ||= 1
      if is_author_or_editor?(@broadcast)
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @broadcast }
          format.json { render :json => @broadcast }
        end
      else
        denied("You need to be an Editor to view this page")
      end
    end
  end

  # GET /broadcasts/new
  # Return a form to browsers to allow broadcasting of a news item. Provides
  # the key functionality of this application
  def new
    @broadcast = Broadcast.new
    @current_page = params[:page] ||= 1
    
    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @broadcast }
    end
  end

  # POST /broadcasts
  # POST /broadcasts.xml
  def create
    @current_page = params[:page] ||= 1

    @broadcast = Broadcast.new(params[:broadcast])
    @broadcast.feed_type = params[:type]
    
    # Wire up broadcast with the current user (an administrator)
    # Will be an admin user (see before_filter)
    # Note the current_user is a user_detail object so we need
    # to navigate to its user object
    @broadcast.user = current_user.user

    # Doing the next line forces a save automatically. I want to defer this
    # until the "if" statement
    #current_user.user.broadcasts << @broadcast

    no_errors = false
    respond_to do |format|
      if @broadcast.save

        # Only after saving do we try and do the real broadcast. Could have been
        # done using an observer, but I wanted this to be more explicit
        results = BroadcastService.broadcast(@broadcast, params[:feeds])
        puts results[:result]
        if results[:result].length > 0
          # Something went wrong when trying to broadcast to one or more of the
          # feeds.
          @broadcast.errors.add_to_base("#{I18n.t('broadcasts.unable-message')}: #{results.inspect}")
          flash[:error] = I18n.t('broadcasts.no-feeds')
        else
          flash[:notice] = "#{I18n.t('broadcasts.saved-message')} #{I18n.t('broadcasts.broadcast-to-feeds')} #{results[:feeds].join(', ')}"
          no_errors = true
        end
        if no_errors
          format.html { redirect_to(broadcasts_path(:page=>@current_page))}
          format.xml { render :xml => @broadcast, :status => :created, :location => @broadcast }
          format.json { render :json => broadcast, :status => :created, :location => @broadcast }
        else
          format.html { render :action => "new" }
          format.xml  {
            # Either say it partly worked but send back the errors or else send
            # back complete failure indicator (couldn't even save)
            if results[:result]
              render :xml => @broadcast.errors, :status => :created, :location => @broadcast
            else
              render :xml => @broadcast.errors, :status => :unprocessable_entity 
            end
          }
          format.xml  {
            # Either say it partly worked but send back the errors or else send
            # back complete failure indicator (couldn't even save)
            if results[:result]
              render :json => @broadcast.errors, :status => :created, :location => @broadcast
            else
              render :json => @broadcast.errors, :status => :unprocessable_entity 
            end
          }
        end
      end
    end
  end


  # DELETE /broadcasts/1
  # DELETE /broadcasts/1.xml
  def destroy
    begin
      @broadcast = Broadcast.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { 
            redirect_to("#{broadcasts_path}?page=1")
            flash[:error] = "Couldn't find the Broadcast to destroy."
          }
          format.xml  { head :not_found, :status => :missing }
          format.json { head :not_found, :status => :missing }
        end
    else
      if is_author_or_editor?(@broadcast)
        @broadcast.destroy
        
        current_page = params[:page] ||= 1

        respond_to do |format|
          format.html { redirect_to(broadcasts_path(:page=>current_page)) }
          format.xml  { head :ok, :status => :success }
          format.json { head :ok, :status => :success }
        end
      else
        denied("You cannot delete this broadcast")
      end
    end
  end

end
