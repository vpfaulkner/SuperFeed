class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :authorizations

  def self.find_or_create_by_auth_hash(auth_hash)
    auth = Authorization.find_or_create_by!(provider: auth_hash["provider"],
                                            uid: auth_hash["uid"])
    auth.update!(token: auth_hash["credentials"]["token"])

    unless auth.user
      auth.create_user!(name: auth_hash["info"]["name"],
                        email: auth_hash["info"]["email"])
      auth.save!
    end

    auth.user
  end
end
