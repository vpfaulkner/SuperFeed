class SesssionsController < ApplicationController

  def create
    @user = User.find_or_create_by_auth_hash(auth_hash, current_user)
    self.current_user = @user
    redirect_to root_url
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
