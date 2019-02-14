class SessionsController < ApplicationController
  def new
    
  end

  def create
    p_s = params[:session]
    user = User.find_by(email: p_s[:email].downcase)
    if user && user.authenticate(p_s[:password])
      if user.activated?
        log_in user
        p_s[:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or(user)
      else
        flash[:warning] = "Account not activated. Check your email for the activation link."
        redirect_to(root_path)
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
