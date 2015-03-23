class Admin::LocationsController < Admin::BaseController  
  def index
  	if current_user.role == :admin
  		@locations = Location.where(:status => 'active')    	
  	else
  		#redirect user to root due to unauthorized access  		
  		redirect_to root_url
  	end
  end
end
