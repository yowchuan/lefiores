class BranchController < ApplicationController
  before_filter :require_login
  before_action :set_store
  before_action :set_branch, only:[:create,:index]  
  before_action :set_days, only:[:new, :create,:index,:edit]

  #dashboard
  def index
    @lefiores_tab_active = :dashboard     
    @store = Store.where(:user_id => current_user.id.to_s).first    
    if @store.has_branch
      @branch = Store::Branch.where(:id => @store.current_branch_id).first;       
    else
      @branch = Store::Branch.new 
    end

  end

  def new  	  	          
      
    if !@store.has_branch?
      if params[:branch_name].present?
        @branch_name = 'main'
        @branch_contact_no = @store.contact_no + '1'
      else
         @branch_name = 'main'
      @branch_contact_no = @store.contact_no
      end
     
    end

    @branch = Store::Branch.new   
    @user = User.where(:id => current_user.id).first    
    @store = Store.where(:user_id => current_user.id.to_s).first 
    @store_branches = @store.branches
     
  end

  #def create
  #	@branch = Store::Branch.new(branch_params)  	  	  
	#  @branch.store_id = @store.id
	  
	#  if @branch.save  	
  #    @store.branch = @branch  	  	 		  			
 # 		uri = root_url
 # 		redirect_to uri, :notice => 'Your shop is now ready and you can now start selling!'+ @store.branch.sub_name and return	  	
  #  else
  #    render :new
  #  end	  
  #end  

  # POST /admin/companies
  # POST /admin/companies.json
  def create    
    if @store.id.present?
      @branch.store_id = @store.id 
    else
      redirect_to root_url, :notice => 'no store id' + @store.id.to_s
    end
    
    if @branch.save!      
      #if @store.update_attribute(:has_branch, true)
        #@store.current_branch_id = @branch.id.to_s;
        #@store.save
      uri = '/store/branch/' + @branch.id.to_s + '/edit_delivery_areas'
      #uri = 'store/branch/' + @branch.id.to_s + '/edit_delivery_areas';        
      redirect_to uri, :notice => 'Your shop is now ready and you can now start selling!'+ @branch.sub_name and return              
      #else
      #  redirect_to root_url, :notice => 'Unable to update store'+ @branch.sub_name and return              
      #end  
    else              
        redirect_to root_url, :notice => 'Unable to save branch'+ @branch.sub_name and return              
    end    
  end

  def destroy	
	  
  end

  def update_delivery_areas
    set_branch

    area_id = params[:branch][:delivery_area]
    delivery_area = Location.where(:id => area_id).first
    
    @branch.delivery_areas.push(delivery_area)    

    if @branch.save!      
      if @store.update_attribute(:has_branch, true)
        @store.current_branch_id = @branch.id.to_s;
        @store.save
        uri = '/store/dashboard/'
        redirect_to uri, :notice => 'Your shop is now ready and you can now start selling!'+ @branch.sub_name and return              
      else
       redirect_to root_url, :notice => 'Unable to update store'+ @branch.sub_name and return              
      end   

    end  

  end  
  #GET
  def edit_delivery_areas
    set_branch
  end  

  def edit
    set_branch    
    @branch = Store::Branch.where(:id => params[:branch_id]).first

  end

  def update
    set_branch
    @branch.sub_name = 'main'
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to '/store/'+@store.id+'/settings', notice: 'Branch was successfully updated.' }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_days
    @days = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
  end

  #settings tab
  def settings    
    @lefiores_tab_active = :settings
  end

  def set_store
    @user = User.where(:id => current_user.id).first    
    @store = @user.store  
    if @store
      @store_branches = @store.branches
    end    
  end  

  def set_branch
    if !@store.has_branch?
      @branch = Store::Branch.new
      @branch_name = 'main'
      @branch_contact_no = @store.contact_no
      @branch.sub_name = 'Main'
      if params[:business_hours_from_monday].present?
        @branch = Store::Branch.new(branch_params)           
      end
    end    
    if !@branch.present?
      @branch = Store::Branch.where(:id => @store.current_branch_id.to_s).first      
    end
      
  end  

  private
  def branch_params    
    
    params.require(:store_branch).permit(:contact_no, :sub_name, :cut_off_time,
                :business_hours_from_monday,
                :business_hours_from_tuesday,
                :business_hours_from_wednesday,
                :business_hours_from_thursday,  
                :business_hours_from_friday,
                :business_hours_from_saturday,
                :business_hours_from_sunday,
                :business_hours_to_monday,
                :business_hours_to_tuesday,
                :business_hours_to_wednesday,
                :business_hours_to_thursday,
                :business_hours_to_friday,
                :business_hours_to_saturday,
                :business_hours_to_sunday)
  end

end
