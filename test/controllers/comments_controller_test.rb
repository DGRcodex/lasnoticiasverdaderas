require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @comment = comments(:one)
  end

  test "should get index" do
    sign_in users(:one)
    get comments_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:one)
    get new_comment_url
    assert_response :success
  end

  test "should create comment" do
    sign_in users(:one)
    assert_difference("Comment.count") do
      post comments_url, params: { comment: { content: @comment.content, news_id: @comment.news_id, user_id: @comment.user_id } }
    end

    assert_redirected_to comment_url(Comment.last)
  end

  test "should show comment" do
    sign_in users(:one)
    get comment_url(@comment)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "should update comment" do
    sign_in users(:one)
    patch comment_url(@comment), params: { comment: { content: @comment.content, news_id: @comment.news_id, user_id: @comment.user_id } }
    assert_redirected_to comment_url(@comment)
  end

  test "should destroy comment" do
    sign_in users(:one)
    assert_difference("Comment.count", -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to comments_url
  end
end
