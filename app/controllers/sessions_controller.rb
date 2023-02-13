class SessionsController < ApplicationController
  # GET /login
  def new
    # @session = Session.new             ✖️ -> model is none
    # scope: :session + url: login_path  ◯　
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      # Success 
      reset_session #ログイン直前に書くことでセッションリプレイ攻撃を防ぐ
      remember user
      log_in(user)
      redirect_to user   # user_url(user)
    else
      # Failed
      # alert-danger -> 赤色フラッシュ
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end  

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

end
