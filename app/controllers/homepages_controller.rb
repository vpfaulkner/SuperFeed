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
      # if current_user.authorizations.find_by(provider: :twitter)
      #   @twitter_feed = Twitter.request_data(current_user.authorizations.find_by(provider: :twitter))
      #   @twitter_feed.each { |message| @feed.push(message) }
      # end
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