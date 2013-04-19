class SessionsController < ApplicationController
  ssl_required :new, :create if SSL_SERVER_BEING_USED
  ssl_allowed :destroy if SSL_SERVER_BEING_USED
  
  skip_before_filter :login_required

  # GET /session/new
  def new
  end

  # POST /session
  def create 
    user_detail = UserDetail.authenticate(params[:login], params[:password])
    if user_detail
      self.current_user = user_detail
      uri = session[:original_uri]
      session[:original_uri] = nil
      redirect_to(uri || home_path)
      flash[:notice] = I18n.t('sessions.login-success')
    else
    	flash[:error] = I18n.t('sessions.login-failure') + " #{params[:login]}"
      render 'new'
    end
  end

  #DELETE /session
  def destroy
    session[:user_id] = nil
    redirect_to home_path
  end

end
