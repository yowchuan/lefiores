class StoreController < ApplicationController
  before_filter :require_login, :except => :show_store
  before_action :set_store, :except => :show_store

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
      
      render :new, :notice => 'store is not updated' and return        
    end
    
  end

  #patch logo for the store
  def set_logo
    authorize! :update, Store
    begin
      @store_image = Store::Image.where(:id => params[:image_id]).first
      @store.store_logo_url = @store_image.file.url
      @store.store_logo_id = @store_image.id
      if @store.update     
        redirect_to '/store/'+@store.id+'/settings',:notice => 'You have successfully set your logo' and return               
      end
    end
    redirect_to '/store/dashboard', :alert => t(:failed_to_set_top_image) and return
  end

  def image_create
    authorize! :update, Store
    store_image = Store::Image.new(store_image_params)

    store_image.store_id = @store.id
    store_image.user_id = current_user.id

    if store_image.save()      
      render :json => {:image_file_url => store_image.file.url, :id => store_image.id.to_s, :image_file_small_url => store_image.file.small.url}
    else
      render :text => 'upload error'
    end
  end

  # GET param branch_id
  def settings
    @branch = Store::Branch.where(:id => @store.current_branch_id).first
    @branch_id = params[:branch_id]
    @lefiores_tab_active = :settings          
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

  def store_image_params    
    params.require(:store_image).permit(:store_id, :user_id, :file )
  end

  def set_store
    @user = User.where(:id => current_user.id).first    
    @store = @user.store    
  end    

  def show_store
    if current_user.role != :admin
      slug = params[:store_slug]
      @store = Store.where(:page_url => slug).first
      @branch = Store::Branch.where(:id => @store.current_branch_id).first

      render :show
    else
      redirect_to '/admin/dashboard'
    end
  end

  private
  def stringify_business_hours branch
    empty = false;
    if branch.business_hours_from_monday
      business_hours = branch.business_hours_from_monday
      empty =true
    end  
    if branch.business_hours_from_tuesday
      business_hours = business_hours + '\n' + branch.business_hours_from_tuesday
      empty =true
    end

    if branch.business_hours_from_wednesday
      business_hours = business_hours + '\n' + branch.business_hours_from_wednesday
      empty =true
    end  

    if branch.business_hours_from_thursday
      business_hours = business_hours + '\n' + branch.business_hours_from_thursday
      empty =true
    end  

    if branch.business_hours_from_friday
      business_hours = business_hours + '\n' + branch.business_hours_from_friday
      empty =true
    end  

    if branch.business_hours_from_saturday
      business_hours = business_hours + '\n' + branch.business_hours_from_tuesday
      empty =true
    end  

    if branch.business_hours_from_sunday
      empty =true
    end    

    #to

    if branch.business_hours_to_monday
      empty =true
    end  
    if branch.business_hours_to_tuesday
      empty =true
    end

    if branch.business_hours_to_wednesday
      empty =true
    end  

    if branch.business_hours_to_thursday
      empty =true
    end  

    if branch.business_hours_to_friday
      empty =true
    end  

    if branch.business_hours_to_saturday
      empty =true
    end  

    if branch.business_hours_to_sunday
      empty =true
    end 
  end  

  def site_params
    params.require(:store).permit(:business_reg_no, :contact_no, :page_url,:name)
  end



 

end
