class ZypeLoginStrategy < ::Warden::Strategies::Base
  def authenticate!
    require "uri"
    require "net/http"

    post_params = {
        client_id: ENV['ZYPE_CLIENT_ID'],
        client_secret: ENV['ZYPE_CLIENT_SECRET'],
        username: params['user']['email'],
        password: params['user']['password'],
        grant_type: 'password'
    }

    response = Net::HTTP.post_form(URI('https://login.zype.com/oauth/token'), post_params)

    body = JSON.parse(response.body)
    if(response.code.eql?("200") && body.has_key?('access_token'))
      @user = User.new(email: params['user']['email'], access_token: body['access_token'])
    end

    @user.nil? ? fail!("Incorrect user and password combination") : success!(user)
  end
end