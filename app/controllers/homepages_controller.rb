class HomepagesController < ApplicationController
  def index
  if logged_in?
    github_authentication = current_user.authorizations.find_by(provider: :github)
    twitter_authentication = current_user.authorizations.find_by(provider: :twitter)
    if github_authentication
      @github_user = HTTParty.get("https://api.github.com/user", { :body => {}, :headers => {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
      @github_username = @github_user["login"]
      @github_response = HTTParty.get("https://api.github.com/users/#{@twitter_username}/received_events", { :body => {}, :headers => {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
    elsif
      @twitter_user = HTTParty.get("https://api.github.com/user", { :body => {}, :headers => {"authorization" => "token #{twitter_authentication.token}", "User-Agent" => "SuperSuperFeed"} })
      @twitter_username = @github_user["login"]
      @twitter_response = HTTParty.get("https://api.github.com/users/#{@twitter_username}/received_events", { :body => {}, :headers => {"authorization" => "token #{twitter_authentication.token}", "User-Agent" => "SuperSuperFeed"} })
    end
  end
  end
end
