class UsersController < ApplicationController
  #GET /users/:id
  def show
    @user = User.find(params[:id])
  end
  #GET /users/new
  def new
    @user=User.new
  end

  #POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      #Success (valid params)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      #Failure (not valid params)
      render 'new', status: :unprocessable_entity
    end
    
    User.create(user_params)
  end  

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
