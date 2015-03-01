class BranchController < ApplicationController
  before_filter :require_login
  before_action :set_store
  before_action :set_days, only:[:new]

  #dashboard
  def index
    @user = User.where(:id => current_user.id).first    
    @store = @user.store
    @lefiores_tab_active = :dashboard     

    if @store.branch.present?
      flash[:notice] = 'This is your dashboard'      
    else      
      @branch_name = 'main'
      @branch_contact_no = @store.contact_no
      #redirect_to '/store/branch/new',:branch_name => @branch_name, :branch_contact_no => @branch_contact_no      
      #redirect_to '/store/branch/new'(:id => 1, :contact_id => 3, :name => 'suleman')
      redirect_to :controller => "branch", :action => "new", :branch_name => @branch_name, :branch_contact_no => @branch_contact_no
    end
  end

  def new  	  	      

    if params[:branch_name].present?
      @branch_name = 'main'
      @branch_contact_no = @store.contact_no + '1'
    end

    if !@store.branch.present?
      @branch_name = 'main'
      @branch_contact_no = @store.contact_no
    end
    @branch = Store::Branch.new   
    @user = User.where(:id => current_user.id).first    
    @store = @user.store  
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
    @branch = Store::Branch.new(branch_params)  
    @branch.store_id = @store.id 

    respond_to do |format|      
      if @branch.save
        @store.branch_id = @branch.id.to_s
        @store.save

        uri = root_url
        redirect_to uri, :notice => 'Your shop is now ready and you can now start selling!'+ @branch.sub_name and return      
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy	
	
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
      @branch = @store.branch
    end    
  end  


  private
  def branch_params    
    
    params.require(:store_branch).permit(:contact_no, :sub_name,
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
