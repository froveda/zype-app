class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable

  private

  ## Don't require a password confirmations since we are loggin the user
  ## through zype login api
  def password_required?
    false
  end
end
