class HomepagesController < ApplicationController
  def index
    @feed = []
    if logged_in?
      if current_user.authorizations.find_by(provider: :github)
        @github_feed = Github.request_data(current_user.authorizations.find_by(provider: :github))
        @github_feed.each { |message| @feed.push(message) }
      elsif current_user.authorizations.find_by(provider: :linkedin)
        @linkedin_feed = Linkedin.request_data(current_user.authorizations.find_by(provider: :linkedin))
        @linkedin_feed.each { |message| @feed.push(message) }
      end
      @feed.sort_by { |message| message[:timestamp] }
    end
  end
end
