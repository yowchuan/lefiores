class BranchController < ApplicationController
  before_filter :require_login
  before_filter :set_store

  #dashboard
  def index
    @user = User.where(:id => current_user.id).first    
    @store = @user.store
    @lefiores_tab_active = :dashboard            
    if @store.branch.present?
      flash[:notice] = 'This is your dashboard'      
    else      
      redirect_to '/store/branch/new', :notice => 'You haven\'t setup your main branch. Lets set it up promise it won\'t take long'
    end
  end

  def new  	  	  
    @branch = Store::Branch.new    
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

  #settings tab
  def settings    
    @lefiores_tab_active = :settings
  end

  def set_store
    @user = User.where(:id => current_user.id).first    
    @store = @user.store  
    @store_branches = @store.branches
    @branch = @store.branch
  end  

  private
  def branch_params
    if params[:store_branch][':cut_off_time(1i)'].present?
      params[:store_branch][:date] = params[:store_branch][':cut_off_time(1i)'] + '-' + params['news'][':cut_off_time(2i)'] + '-' + params['news'][':cut_off_time(3i)'] + 'T' + params[:store_branch][':cut_off_time(4i)'] + ':' + params[:store_branch][':cut_off_time(5i)'] + ":00Z"
      params[:store_branch].delete(':cut_off_time(1i)')
      params[:store_branch].delete(':cut_off_time(2i)')
      params[:store_branch].delete(':cut_off_time(3i)')
      params[:store_branch].delete(':cut_off_time(4i)')
      params[:store_branch].delete(':cut_off_time(5i)')
    end
    if params[:store_branch]['cut_off_time(1i)'].present?
      params[:store_branch][:cut_off_time] = params[:store_branch]['cut_off_time(1i)'];
    end
    params.require(:store_branch).permit(:postal_code, :contact_no, :sub_name,:business_hours)
  end

end
