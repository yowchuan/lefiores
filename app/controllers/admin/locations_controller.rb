class Admin::LocationsController < Admin::BaseController  
  def index
  	if current_user.role == :admin
  		@locations = Location.where(:status => 'active')    	
  	else
  		#redirect user to root due to unauthorized access  		
  		redirect_to root_url
  	end
  end

  # GET /admin/state/new
  def new
    authorize! :create, Location

    @location = Location.new
  end

  def create

    authorize! :create, Location    

    @location = Location.new(location_params)        
    city_id = params[:location][:location_city]
    state_id = params[:location][:location_state]

    
    #setup city
    if city_id.present?      
      @city = Location::City.where(:id => city_id).first
      if @city.present?
        @location.city_id = @city.id.to_s        
      end
    end

    #setup state
    if state_id.present?
      @state = Location::State.where(:id => state_id).first
      if @state.present?
        @location.state_id = @state.id.to_s
      end
    end

    if @location.save
      uri = '/admin/locations/';

      redirect_to uri, notice: 'location added: ' + @city.name and return
    else
      #@news_list = get_news
      render :new
    end
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
