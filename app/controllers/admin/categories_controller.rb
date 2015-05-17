class Admin::CategoriesController < Admin::BaseController  
  def index
  	if current_user.role == :admin
  		@categories = Store::Product::Category.all
  	else
  		#redirect user to root due to unauthorized access  		
  		redirect_to root_url
  	end
  end

  # GET /admin/category/new
  def new
    authorize! :create, Store::Product::Category
    @category = Store::Product::Category.new
  end

  def create

    authorize! :create, Store::Product::Category

    @category = Store::Product::Category.new(category_params)            

    if @category.save
      uri = '/admin/categories/';
      redirect_to uri, notice: 'category added: ' + @category.name and return
    else      
      render :new
    end
  end
  #GET
  def edit
    authorize! :update, Store::Product::Category
    @category = Store::Product::Category.where(:id => params[:category_id]).first
  end

  # def update
  #   authorize! :update, Store::Product::Category
  #   @category = Store::Product::Category.where(:id=>params[:id]).first

  # end
  def update
    @category = Store::Product::Category.where(:id=>params[:id]).first    
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to '/admin/categories', notice: @category.name + ' category successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params      
      params.require(:store_product_category).permit(:name, :description);
    end
end
