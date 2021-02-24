class SessionsController < ApplicationController

  def new 

  end

  def create 
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to (session[:intended_url] || user), 
                notice: "Welcome back, #{user.name}!"
      session[:intended_url] = nil
    else
      flash.now[:alert] = "Invalid password/email combination!"
      render :new 
    end
  end

  def destroy 
    session[:user_id] = nil
    redirect_to events_url, notice: "Successfully signed out!"
  end
end
