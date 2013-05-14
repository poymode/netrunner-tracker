class SessionsController < ApplicationController
  # TODO: Bug in routes? Shouldn't have to do this.
  def new
    if request.post?
      create
    end
  end

  def create
    user = User.find_by_email(params[:email])

    if user
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    else
      redirect_to login_url, :alert => "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notice => "Logged out"
  end
end
