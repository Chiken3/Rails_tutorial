class SessionsController < ApplicationController
  # GET /login
  def new
    # @session = Session.new             ✖️ -> model is none
    # scope: :session + url: login_path  ◯　

  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # Success 
      login(user)
      # user_url(user)
      redirect_to user
    else
      # Failed
      # alert-danger -> 赤色フラッシュ
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end  

  def delete
  end

end
