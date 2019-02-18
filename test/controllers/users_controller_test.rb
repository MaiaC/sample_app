require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @user = users(:michael)
    @user2 = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to(login_path)
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not(flash.empty?)
    assert_redirected_to(login_path)
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not(flash.empty?)
    assert_redirected_to(login_path)
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get edit_user_path(@user)
    assert(flash.empty?)
    assert_redirected_to(root_path)
  end

  test "should redirect update when looged in as wrong user" do
    log_in_as(@user2)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert(flash.empty?)
    assert_redirected_to(root_path)
  end

  test "should redirect new when logged in" do
    log_in_as(@user)
    get signup_path
    assert_not(flash.empty?)
    assert_redirected_to(@user)
    get root_path
    assert_select("a[href=?]", signup_path, count: 0)
  end

  test "should redirect create when logged in" do
    log_in_as(@user)
    post signup_path, params: { user: { name: "Example",
                              email: "abcdefghijkl@mnopqrstuv.wxyz",
                              password: "password",
                              password_confirmation: "password" } }
    assert_nil(User.find_by(email: "abcdefghijkl@mnopqrstuv.wxyz"))
    assert_not(flash.empty?)
    assert_redirected_to(@user)
    get root_path
    assert_select("a[href=?]", signup_path, count: 0)
  end

  test "should not allow admin attribute to be edited via the web" do
    log_in_as(@user2)
    assert_not(@user2.admin?)
    patch user_path(@user2), params: { user: { password: "password",
                                  password_confirmation: "password",
                                  admin: true } }
    assert_not(@user2.admin?)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference("User.count") do
      delete user_path(@user)
    end
    assert_redirected_to(login_path)
  end

  test "should redirect destroy when logged in as a non-admin" do 
    log_in_as(@user2)
    assert_no_difference("User.count") do
      delete user_path(@user)
    end
    assert_redirected_to(root_path)
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end
