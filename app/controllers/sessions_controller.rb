class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.block?
      flash.now[:danger] = t "flash.blocked"
      render :new
    elsif user&.authenticate params[:session][:password]
      activate_check user
    else
      flash.now[:danger] = t "flash.login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def remember_user user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def activate_check user
    if user.activated?
      log_in user
      remember_user user
      redirect_back_or user
    else
      flash[:warning] = t "activate_mail.message"
      redirect_to root_url
    end
  end
end
