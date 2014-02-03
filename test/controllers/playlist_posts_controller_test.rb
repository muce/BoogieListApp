require 'test_helper'

class PlaylistPostsControllerTest < ActionController::TestCase
  setup do
    @playlist_post = playlist_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:playlist_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create playlist_post" do
    assert_difference('PlaylistPost.count') do
      post :create, playlist_post: { playlist_id: @playlist_post.playlist_id, post_id: @playlist_post.post_id }
    end

    assert_redirected_to playlist_post_path(assigns(:playlist_post))
  end

  test "should show playlist_post" do
    get :show, id: @playlist_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @playlist_post
    assert_response :success
  end

  test "should update playlist_post" do
    patch :update, id: @playlist_post, playlist_post: { playlist_id: @playlist_post.playlist_id, post_id: @playlist_post.post_id }
    assert_redirected_to playlist_post_path(assigns(:playlist_post))
  end

  test "should destroy playlist_post" do
    assert_difference('PlaylistPost.count', -1) do
      delete :destroy, id: @playlist_post
    end

    assert_redirected_to playlist_posts_path
  end
end
