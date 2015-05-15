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

    authorize! :create, Location    

    @location = Location.new(location_params)        
    city_id = params[:location][:location_city]
    state_id = params[:location][:location_state]

    @location.name = @location.zipcode
    #setup city
    if city_id.present?      
      @city = Location::City.where(:id => city_id).first
      if @city.present?
        @location.city_id = @city.id.to_s        
        @location.name = @location.name + ' ' + @city.name
      end

    end

    #setup state
    if state_id.present?
      @state = Location::State.where(:id => state_id).first
      if @state.present?
        @location.state_id = @state.id.to_s
        @location.name = @location.name + ', ' + @state.name
      end
    end


    #@location.name = @location.zipcode + ' ' + @state.name + ' ' + @city.name 

    if @location.save
      uri = '/admin/locations/';

      redirect_to uri, notice: 'location added: ' + @location.name and return
    else
      @news_list = get_news
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
    def location_params
      if params[:location][:keywords].present?
        params[:location][:keywords] = params[:location][:keywords].split(',').join(',')
      end
      params.require(:location).permit(:zipcode);
    end
end
