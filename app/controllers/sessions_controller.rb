class SessionsController < ApplicationController
  skip_before_filter :store_current_location

  def new
    @user = User.new
  end

  def create
    warden.authenticate!
    redirect_to stored_location
  end

  def login_fail
    @user = User.new(email: params['user']['email'])
    @error = t('errors.email_password_combination')
    render 'new'
  end

  def logout
    logout_user
    redirect_to root_path
  end
end