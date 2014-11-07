class Linkedin < ActiveRecord::Base

  def self.request_data(linkedin_authentication)
    # Make linkedin API request with linkedin_authentication
    # Call transform_data function with response
    # Return linkedin feed
  end

  def self.transform_data(linkedin_response)
    # Return array of hashes for linkedin messages
  end
end
