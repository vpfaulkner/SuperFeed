class HomepagesController < ApplicationController
  def index
  # if logged_in?
  #   gh_auth = current_user.authorizations.find_by(provider: :github)
  #   if gh_auth
  #     response = RestClient.get("https://api.github.com/user/repos",
  #                               { authorization: "token #{gh_auth.token}" })
  #     @repos = JSON.parse(response.body)
  #   end
  # end
  end
end
