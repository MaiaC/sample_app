require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "post interface" do
    log_in_as(@user)
    get root_path
    assert_select("div.pagination")
    assert_select("input", type: "file")
    #Invalid submission
    assert_no_difference("Post.count") do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select("div#error_explanation")
    #Valid submission
    content = "This post is not micro!"
    picture = fixture_file_upload("test/fixtures/rails.png", "image/png")
    assert_difference("Post.count") do
      post posts_path, params: { post: { content: content,
                                          picture: picture } }
    end
    apost = assigns(:post)
    assert(apost.picture?)
    assert_redirected_to(root_path)
    follow_redirect!
    assert_match(content, response.body)
    #Delete post
    assert_select("a", text: "Delete")
    first_post = @user.posts.paginate(page: 1).first
    assert_difference("Post.count", -1) do
      delete post_path(first_post)
    end
    #No delete links when visit different user
    get user_path(users(:archer))
    assert_select("a", text: "Delete", count: 0)
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match("#{@user.posts.count} posts", response.body)
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match("0 posts", response.body)
    other_user.posts.create!(content: "A micropost")
    get root_path
    assert_match("1 post", response.body)
  end
end
