class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :authorizations

  def self.find_or_create_by_auth_hash(auth_hash, current_user)
    auth = Authorization.find_or_create_by!(provider: auth_hash["provider"],
                                            uid: auth_hash["uid"])
    auth.update!(token: auth_hash["credentials"]["token"])

    if current_user
      auth.update!(user_id: current_user.id)

    else
      unless auth.user
        if auth_hash["provider"] == "twitter"
          auth_hash["info"]["email"] = "#{auth_hash["info"]["name"]}@#{auth_hash["info"]["name"]}.com"
        end

        auth.create_user!(name: auth_hash["info"]["name"],
                          email: auth_hash["info"]["email"])
        auth.save!
      end
    end
    auth.user
  end
end
