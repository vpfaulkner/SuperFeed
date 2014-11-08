class Linkedin < ActiveRecord::Base

  def self.request_data(linkedin_authentication)
    linkedin_response = HTTParty.get("https://api.linkedin.com/v1/people/~/network/updates", { :body => {}, :headers => {"Authorization" => "Bearer #{linkedin_authentication.token}"}})
    linkedin_feed = transform_data(linkedin_response)
  end

  def self.transform_data(linkedin_response)
    feed = []
    linkedin_response["updates"]["update"].each do |item|
      item_hash = {}
      item_hash[:image_url] = "Linkedin.png"
      item_hash[:timestamp] = Time.at(item["timestamp"].to_f / 1000).iso8601
      if item["update_type"] == "SHAR"
        item_hash[:name] = "#{item["update_content"]["person"]["first_name"]} #{item["update_content"]["person"]["last_name"]}"
        item_hash[:name_image_url] = item["update_content"]["person"]["picture_url"]
        item_hash[:text] = item["update_content"]["person"]["current_share"]["comment"]
        item_hash[:destination_url] = item["update_content"]["person"]["site_standard_profile_request"]["url"]
      elsif item["update_type"] == "CONN"
        item_hash[:name] = "#{item["update_content"]["person"]["first_name"]} #{item["update_content"]["person"]["last_name"]}"
        item_hash[:name_image_url] = item["update_content"]["person"]["picture_url"]
        item_hash[:text] = "#{item["update_content"]["person"]["first_name"]} #{item["update_content"]["person"]["last_name"]} has a new connection: #{item["update_content"]["person"]["connections"]["person"]["first_name"]}"\
        " #{item["update_content"]["person"]["connections"]["person"]["last_name"]}"
        item_hash[:destination_url] = item["update_content"]["person"]["site_standard_profile_request"]["url"]
      elsif item["update_type"] == "CMPY"
        item_hash[:name] = item["update_content"]["company"]["name"]
        item_hash[:name_image_url] = "Linkedin.png"
        item_hash[:text] = item["update_content"]["company_status_update"]["share"]["comment"]
        item_hash[:destination_url] = item["update_content"]["company_status_update"]["share"]["content"]["submitted_url"]
      elsif item["update_type"] == "PFOL"
        item_hash[:name] = "#{item["update_content"]["person"]["first_name"]} #{item["update_content"]["person"]["last_name"]}"
        item_hash[:name_image_url] = item["update_content"]["person"]["picture_url"]
        item_hash[:text] = item["update_content"]["company_status_update"]["share"]["comment"]
        item_hash[:destination_url] = item["update_content"]["company_status_update"]["share"]["content"]["submitted_url"]

      end
      feed.push(item_hash)
    end
    feed
  end
end
