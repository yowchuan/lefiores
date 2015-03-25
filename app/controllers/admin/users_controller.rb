class Admin::UsersController < Admin::BaseController  
  load_and_authorize_resource 

  # GET admin/users
  # GET admin/users.json
  def index
    
    if current_user.role == :admin
      @users = User.all
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize! :read, @user
    set_user
  end

  # GET /users/new
  def new
    @user = User.new
    @type = params[:type]
  end

  # GET /users/1/edit
  def edit
  end


  def update
    #@user = User.find(params[:id])
    if @user.update(user_params)
      #respond_with(@news)
      uri = '/admin/users/' + @user.id
      redirect_to uri, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

end
