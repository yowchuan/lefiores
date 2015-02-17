class UserSessionsController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	remember_me = false
    if params[:user][:remember_me].present? and params[:user][:remember_me] == true
      remember_me = true
    end
    email = params[:user][:email]
    password = params[:user][:password]
    user = login(email, password, remember_me)

    #if user
    if session[:user_id].present?
      #if store isn't setup yet
      if !user.has_store
        uri = '/store/new'
        msg = 'welcome to lefiores!'
      else        
        uri = root_url          
        msg = 'welcome back!'
      end
      redirect_back_or_to uri, :notice => msg
    else
      flash.now.alert = 'login failed.'
      render :new
    end
  end

  def destroy	
	session.clear	
	redirect_to root_url, :notice => 'Goodbye! Thanks for using lefiores!'
  end

end
