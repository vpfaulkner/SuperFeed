class HomepagesController < ApplicationController
  def index
    @feed = []
    return unless logged_in?
    @feed = Github.push_feed(@feed, current_user)
    @feed = Linkedin.push_feed(@feed, current_user)
    @feed = Twitter.push_feed(@feed, current_user)
    @feed = standardize_feed_timestamp(@feed)
    @feed = sort_feed(@feed)
  end

  def destroy_authorization
    auth = current_user.authorizations.find_by(provider: params["provider"])
    auth.destroy
    redirect_to root_path
  end

  def sort_feed(feed)
    feed.sort!{|a,b| b[:timestamp] <=> a[:timestamp]}
  end

  def standardize_feed_timestamp(feed)
    feed.each { |message| message[:timestamp] = message[:timestamp].to_time.iso8601 }
  end

end
