class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      if user.activated
        login_remember user
      else
        message = t "message_warning_active"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = t "fail_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
