require 'test_helper'

class HomepagesControllerTest < ActionController::TestCase
  context "index action" do

    should "Create feed" do
      get :index, {}, {current_user_id: users(:three).id}

      assert assigns[:feed]
      assert assigns[:github_feed]
    end

    should "destory authorization" do

      delete :destroy_authorization, {:provider => :github}, {current_user_id: users(:three).id}

      get :index, {}, {current_user_id: users(:three).id}

      refute assigns[:github_feed]

    end

  end
end
