class Twitter < ActiveRecord::Base

  def self.push_feed(feed, current_user)
    if current_user.authorizations.find_by(provider: :twitter)
      @twitter_feed = Twitter.request_data(current_user.authorizations.find_by(provider: :twitter))
      @twitter_feed.each { |message| feed.push(message) }
    end
    feed
  end

  def self.request_data(twitter_authentication)
#    twitter_response = HTTParty.get("https://api.twitter.com/1.1/statuses/home_timeline.json", { :body => {}, :headers => {"authorization" => "token #{twitter_authentication.token}", "User-Agent" => "SuperSuperFeed"} })
#    twitter_feed  = transform_data(twitter_response)
#    twitter_feed
    {} # return null hash so code can run but no twitter data
  end


end
