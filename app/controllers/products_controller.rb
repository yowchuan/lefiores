class ProductsController < ApplicationController
  before_filter :require_login  
  before_action :set_store,:set_active_tab
  #dashboard
  def index
    authorize! :update, @store
    
    @store = Store.where(:user_id => current_user.id.to_s).first               
    @products = Store::Product.where(:store_id => @store.id)            
  end

  def new  	  	          
    @store = Store.where(:user_id => current_user.id.to_s).first               
    @product = Store::Product.new 
  end

  def create   
    authorize! :update, @store
    @product = Store::Product.new(product_params) 
    @product_image = Store::Image.where(:id => @product.id).first

    #@product.category = @category

    if @store.id.present?
      @product.store_id = @store.id 
    else
      redirect_to root_url, :notice => 'no store id illegal access' + @store.id.to_s
    end
    
    if @product.save
      uri = '/store/' + @store.id + '/catalog'
      #uri = 'store/branch/' + @branch.id.to_s + '/edit_delivery_areas';        
      redirect_to uri, :notice => 'Product Added!' and return               
    else              
        render :new
    end    
  end

  def destroy
    authorize! :destroy, @store
    uri = '/store/' + @store.id + '/catalog'    
    @product = Store::Product.where(:id => params[:product_id]).first
    @product_image = Store::Product::Image.where(:product_id => @product.id).first
    if @product_image.present?
      @product_image.destroy
    end


    if @product.destroy      
        redirect_to uri, :notice => 'deleted' and return
    end
    redirect_to uri, notice: 'deleted' and return    
  end

  def deactivate
    authorize! :destroy, @store
    uri = '/store/' + @store.id + '/catalog'    
    @product = Store::Product.where(:id => params[:product_id]).first
    @product.status = :inactive
    if @product.save
        redirect_to uri, :notice => 'product deactivated' and return
    end
    redirect_to uri, notice: 'deleted' and return    
  end

  def image_create
    authorize! :update, Store
    product_image = Store::Product::Image.new(product_image_params)

    #product_image.product_id = params[:product_image][:product_id]
    product_image.user_id = current_user.id
    product_image.user_id = @store.id

    if product_image.save()      
      render :json => {:image_file_url => product_image.file.url, :id => product_image.id.to_s, :image_file_small_url => product_image.file.small.url}
    else
      render :text => 'upload error'
    end
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
    @product = Store::Product.where(:id => params[:product_id]).first
  end

  def update
    @product = Store::Product.where(:id => params[:product_id]).first
    uri = '/store/' + @store.id + '/catalog'
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to uri, notice: @product.name + ' successfully updated.' }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end
  private
  def set_store
    @user = User.where(:id => current_user.id).first    
    @store = @user.store  
    if @store
      @store_branches = @store.branches
    end    
  end  

  def product_image_params    
    params.require(:product_image).permit(:store_id,:product_id, :file )
  end

  def product_params
    params.require(:store_product).permit(:name,:product_id, :description,:price,:pic,:product_category_id)      
  end

  def set_active_tab
    @lefiores_tab_active = :catalog     
  end
end
