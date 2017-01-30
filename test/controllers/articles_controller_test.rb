require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "should get my_interests" do
    get :my_interests
    assert_response :success
  end

end
