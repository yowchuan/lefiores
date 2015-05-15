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

  def import
    Location.import(params[:file])
    redirect_to '/admin/locations', notice: "Locations imported."  
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @city = Location::State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params      
      params.require(:store_product_category).permit(:name, :description);
    end
end
