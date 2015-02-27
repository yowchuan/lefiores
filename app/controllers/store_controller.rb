class StoreController < ApplicationController
  before_filter :require_login  
  before_action :set_store

  def new
    @user = User.where(:id => current_user.id).first    
    if @user.has_store
  	  @store = Store.find(:id => @user.store.id);  	  	
    else
      @store = Store.new 
    end
  end

  def create
  	@store = Store.new(site_params)
  	@store.user_id = current_user.id.to_s
  	@store.user_email = current_user.email 

	  @user = User.where(:id => current_user.id.to_s).first
	  if @user
	  	@user.has_store = true		        
	  	#@user.errors.full_messages 
	  end
	  
    if @store.save
      if @user.update_attribute(:has_store, true)
        #uri = '/' + @store.name + '/dashboard'
        uri = '/store/dashboard'
        redirect_to uri, :notice => 'Your shop is now ready and you can now start selling!' and return        
        #format.json { render :show, status: :created, location: @store }
      else
        uri = '/store/dashboard'
        redirect_to uri, :notice => 'User is not updated' and return        
      end  
    else      
      uri = '/store/dashboard'
      redirect_to uri, :notice => 'Store is not updated' and return        
    end
    
  end
  
  def update
    respond_to do |format|
      if @store.update(site_params)
        format.html { redirect_to '/store/settings', notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end  

  def destroy	
	
  end  

  def set_store
    @user = User.where(:id => current_user.id).first    
    @store = @user.store    
  end  

  private
  def site_params
    params.require(:store).permit(:business_reg_no, :contact_no, :page_url,:name)
  end

 

end
