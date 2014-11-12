class Github < ActiveRecord::Base

  def self.push_feed(feed, current_user)
    if current_user.authorizations.find_by(provider: :github)
      @github_feed = Github.request_data(current_user.authorizations.find_by(provider: :github))
      @github_feed.each { |message| feed.push(message) }
    end
    feed
  end

  def self.request_data(github_authentication)
      github_user = HTTParty.get("https://api.github.com/user", { body: {}, headers: {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
      github_username = github_user["login"]
      github_response = HTTParty.get("https://api.github.com/users/#{github_username}/received_events", { body: {}, headers: {"authorization" => "token #{github_authentication.token}", "User-Agent" => "SuperFeed"} })
      github_feed  = transform_data(github_response)
      github_feed
  end

  def self.transform_data(github_response)
    feed = []
    github_response.each do |item|
      begin
        item_hash = {}
        item_hash[:image_url] = "Octocat.png"
        item_hash[:name_image_url] = item["actor"]["avatar_url"]
        item_hash[:timestamp] = item["created_at"]
        item_hash[:source] = "github"
        item_hash[:name] = item["actor"]["login"]
        if item["type"] == "CreateEvent"
          item_hash[:text] = "created repository #{item["repo"]["name"]}"
          item_hash[:destination_url] = item["repo"]["url"]
        elsif item["type"] == "ForkEvent"
          item_hash[:text] = "forked #{item["repo"]["name"]} to #{item["payload"]["forkee"]["full_name"]}"
          item_hash[:destination_url] = item["payload"]["forkee"]["url"]
        elsif item["type"] == "PushEvent"
          item_hash[:text] = "pushed to #{item["repo"]["name"]} #{item["payload"]["commits"][0]["message"]}"
          item_hash[:destination_url] = item["repo"]["url"]
        elsif item["type"] == "MemberEvent"
          item_hash[:text] = "#{item["payload"]["action"]} #{item["payload"]["member"]["login"]} to #{item["repo"]["name"]}"
          item_hash[:destination_url] = item["repo"]["url"]
        elsif item["type"] == "PullRequestEvent"
          item_hash[:text] = "#{item["payload"]["action"]} pull request from #{item["repo"]["name"]}"
          item_hash[:destination_url] = item["repo"]["url"]
        end
      rescue
      else
        feed.push(item_hash)
      end
    end
    feed
  end

end
