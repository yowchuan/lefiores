class Admin::CitiesController < Admin::BaseController  
  def index
  	if current_user.role == :admin
  		@cities = Location::City.where(:status => 'active')    	
  	else
  		#redirect user to root due to unauthorized access  		
  		redirect_to root_url
  	end
  end

  # GET /admin/genres/new
  def new
    authorize! :create, Location::City

    @city = Location::City.new
  end

  # POST /admin/create  
  def create
    authorize! :create, Location::City

    @city = Location::City.new(city_params)

    if @city.save
      redirect_to '/admin/cities' , notice: 'City was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = Location::City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:location_city).permit(:name)
    end
end
