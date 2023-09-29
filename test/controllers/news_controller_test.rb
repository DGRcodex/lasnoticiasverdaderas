require "test_helper"

class NewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @news = news(:one)
  end

  test "should get index" do
    get news_index_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:one)
    get new_news_url
    assert_response :success
  end

  test "should create news" do

    sign_in users(:one)

    assert_difference("News.count") do
      post news_index_url, params: { news: { description: @news.description, imagen: @news.imagen, title: @news.title, user_id: @news.user_id } }
    end

    assert_redirected_to news_url(News.last)
  end

  test "should show news" do
    get news_url(@news)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_news_url(@news)
    assert_response :success
  end

  test "should update news" do
    sign_in users(:one)
    patch news_url(@news), params: { news: { description: @news.description, imagen: @news.imagen, title: @news.title, user_id: @news.user_id } }
    assert_redirected_to news_url(@news)
  end

  test "should destroy news" do
    sign_in users(:one)
    assert_difference("News.count", -1) do
      delete news_url(@news)
    end

    assert_redirected_to news_index_url
  end
end
