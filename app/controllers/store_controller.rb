class StoreController < ApplicationController
  before_filter :require_login
  def new
  	@store = Store.new  	
  	@user = User.where(:id => current_user.id).first	  
  end

  def create
  	@store = Store.new(site_params)
  	@store.user_id = current_user.id.to_s
  	@store.user_email = current_user.email 

	  @user = User.where(:id => current_user.id.to_s).first
	  if @user
	  	@user.has_store = true		        
	  	@user.errors.full_messages 
	  end
	  
	  
	  if @store.save  	  	  	 		  
			if @user.update_attribute(:has_store, true)
	  		#uri = '/' + @store.name + '/dashboard'
	  		uri = root_url
	  		redirect_to uri, :notice => 'Your shop is now ready and you can now start selling!' and return
	  	end		  		 
    else
      render :new
    end	  
  end  

  def destroy	
	
  end

  private
  def site_params
    params.require(:store).permit(:business_reg_no, :contact_no, :page_url)
  end

end
