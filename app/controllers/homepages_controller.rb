class HomepagesController < ApplicationController
  @feed = []
  def index
    @feed = []
    if logged_in?
      if current_user.authorizations.find_by(provider: :github)
        @github_feed = Github.request_data(current_user.authorizations.find_by(provider: :github))
        @github_feed.each { |message| @feed.push(message) }
      end
      if current_user.authorizations.find_by(provider: :linkedin)
        @linkedin_feed = Linkedin.request_data(current_user.authorizations.find_by(provider: :linkedin))
        @linkedin_feed.each { |message| @feed.push(message) }
      end
      if current_user.authorizations.find_by(provider: :twitter)
        @twitter_username = @twitter_user["login"]
        @twitter_response = HTTParty.get("https://api.twitter.com/1.1/search/tweets.json#{@twitter_username}", { :body => {}, :headers => {"authorization" => "token #{twitter_authentication.token}", "User-Agent" => "SuperSuperFeed"} })
      end
      @feed.each { |message| message[:timestamp] = message[:timestamp].to_time.iso8601 }

      @feed.sort!{|a,b| b[:timestamp] <=> a[:timestamp]}
    end

  end

  def destroy_authorization
    auth = current_user.authorizations.find_by(provider: params["provider"])
    auth.destroy
    redirect_to root_path
  end
end
