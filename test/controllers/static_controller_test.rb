require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest

  test "#index is the root_url" do
    get root_url
    assert_response :success
  end
end
