require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "user validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
  end

  context "User class" do
    should "be able to create a new user via auth_hash" do
      auth_hash = { "provider" => "github",
                    "uid" => "1",
                    "info" => {
                        "name" => "Test User",
                        "email" => "user@user.org"
                    },
                    "credentials" => { "token" => "TOKEN" }
                  }
      user = User.find_or_create_by_auth_hash(auth_hash, nil)
      assert_not_nil user
      assert_equal "Test User", user.name
      assert user.persisted?
      assert_includes user.authorizations,
                      Authorization.find_by(provider: "github", uid: "1")
    end

    should "be able to find an existing user via auth_hash" do
      auth = authorizations(:one)
      auth_hash = { "provider" => auth.provider,
                    "uid" => auth.uid,
                    "info" => {},
                    "credentials" => { "token" => auth.token } }


      user = User.find_or_create_by_auth_hash(auth_hash, nil)
      assert_equal auth.user, user
    end
  end


end
