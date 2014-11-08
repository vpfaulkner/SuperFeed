class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :authorizations

  def self.find_or_create_by_auth_hash(auth_hash, current_user)
    auth = Authorization.find_or_create_by!(provider: auth_hash["provider"],
                                            uid: auth_hash["uid"])
    auth.update!(token: auth_hash["credentials"]["token"])

    if current_user
      auth.update!(user_id: current_user.id)
    
    else
      unless auth.user
        auth.create_user!(name: auth_hash["info"]["name"],
                          email: auth_hash["info"]["email"])
        auth.save!
      end
    end
    auth.user
  end
end
