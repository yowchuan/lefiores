class Admin::UsersController < Admin::BaseController  

  # GET admin/users
  # GET admin/users.json
  def index
    authorize!
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


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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
      params.require(:user).permit(:email, :password, :password_confirmation, :type)
    end

end
