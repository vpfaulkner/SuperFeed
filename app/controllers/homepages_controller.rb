class HomepagesController < ApplicationController
  def index
  if logged_in?
    github_authentication = current_user.authorizations.find_by(provider: :github)
    if github_authentication
      @github_response = HTTParty.get('https://api.github.com/user/repos', { :body => {}, :headers => {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
    end
  end
  end
end
