require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get posts_index_url
    assert_response :success
  end

  test "should get create_post" do
    get posts_create_post_url
    assert_response :success
  end
end
