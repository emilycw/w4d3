class SessionsController < ApplicationController
  before_action :require_not_logged_in, only:[:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:session][:user_name],
                                            params[:session][:password])
    if @user
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Invalid login credentials"]
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:user_name] = nil
    session[:password] = nil
    flash.now[:status] = ["Successful logout!"]
    redirect_to cats_url
  end
end
