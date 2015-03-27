class Admin::WelcomeController < Admin::BaseController  
  def index
  	if current_user.role == :admin
  		flash[:notice] = 'hello sir!'
  	else
  		redirect_to root_url
  	end
  end
end
