class HomepagesController < ApplicationController
  def index
    @feed = []
    if logged_in?
      @github_feed = Github.get_data(current_user.authorizations.find_by(provider: :github))
      @github_feed.each { |message| @feed.push(message) }
      # Reorder @feed by timestamp
    end


    # DELETE
    # if logged_in?
    #   github_authentication = current_user.authorizations.find_by(provider: :github)
    #   if github_authentication
    #     @github_user = HTTParty.get("https://api.github.com/user", { :body => {}, :headers => {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
    #     @github_username = @github_user["login"]
    #     @github_response = HTTParty.get("https://api.github.com/users/#{@github_username}/received_events", { :body => {}, :headers => {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
    #   end
    # end

  end
end
