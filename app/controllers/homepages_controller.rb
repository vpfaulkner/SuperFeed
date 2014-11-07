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
      @twitter_username = @twitter_user["login"]
      @twitter_response = HTTParty.get("https://api.twitter.com/1.1/search/tweets.json#{@twitter_username}", { :body => {}, :headers => {"authorization" => "token #{twitter_authentication.token}", "User-Agent" => "SuperSuperFeed"} })
    end
  end
  end
end
