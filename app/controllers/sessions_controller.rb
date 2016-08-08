class SessionsController < Devise::SessionsController
  def new
    @user = User.new
    super
  end

  def create
    response = zype_login()

    body = JSON.parse(response.body)
    if(response.code.eql?("200") && body.has_key?('access_token'))
      self.resource = User.find_or_create_by(email: params['user']['email'])
      self.resource.update_attributes(access_token: body['access_token'])
      sign_in(resource_name, resource)

      redirect_to stored_location_for(:user)
    else
      self.resource = User.new(email: params['user']['email'])
      @error = "Incorrect user and password combination"
      render 'new'
    end
  end

  private
  def zype_login
    require "uri"
    require "net/http"

    post_params = {
        client_id: ENV['ZYPE_CLIENT_ID'],
        client_secret: ENV['ZYPE_CLIENT_SECRET'],
        username: params['user']['email'],
        password: params['user']['password'],
        grant_type: 'password'
    }

    Net::HTTP.post_form(URI('https://login.zype.com/oauth/token'), post_params)
  end
end