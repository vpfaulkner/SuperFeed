class SesssionsController < ApplicationController

  def create
    @user = User.find_or_create_by_auth_hash(auth_hash)
    self.current_user = @user
    binding.pry
    redirect_to root_url
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
