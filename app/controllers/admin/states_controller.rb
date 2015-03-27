class Admin::StatesController < Admin::BaseController  
  def index
  	if current_user.role == :admin
  		@states = Location::State.where(:status => 'active')    	
  	else
  		#redirect user to root due to unauthorized access  		
  		redirect_to root_url
  	end
  end

  # GET /admin/state/new
  def new
    authorize! :create, Location::State

    @state = Location::State.new
  end

  # POST /admin/state/create  
  def create
    authorize! :create, Location::State

    @state = Location::State.new(state_params)

    if @state.save
      redirect_to '/admin/states' , notice: 'State was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @city = Location::State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      params.require(:location_state).permit(:name)
    end
end
