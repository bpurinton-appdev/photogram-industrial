require "rails_helper"

describe "New User record" do
  before do
    sign_in_user if user_model_exists?
  end
  
  it "has a default `likes_count` of 0", points: 1 do
    expect(@user.likes_count).to eq(0),
      "Expected a new user to have a default `likes_count` of 0. Did you make the change in your user migration file?"
  end

  it "has a default `comments_count` of 0", points: 1 do
    expect(@user.comments_count).to eq(0),
      "Expected a new user to have a default `comments_count` of 0. Did you make the change in your user migration file?"
  end
end

describe "The home page" do
  before do
    sign_in_user if user_model_exists?
  end

  it "has a bootstrap navbar", points: 1 do
    visit "/"

    expect(page).to have_selector("nav[class^='navbar']"),
      "Expected home page to have a bootstrap navbar <nav class='navbar ...'> ."
  end

  it "has an edit profile link for the signed in user", points: 1 do
    visit "/"

    expect(page).to have_selector("a[href='/users/edit']", text: "Edit #{@user.username}"),
      "Expected home page to have 'Edit [USERNAME]' link with the username of the signed in user."
  end

  it "has a sign out link with a DELETE request for the signed in user", points: 1 do
    visit "/"

    expect(page).to have_selector("a[href='/users/sign_out'][data-method='delete']"),
      "Expected home page to have 'Sign out' link with the proper data-method='delete' if the user is signed in."
  end

  it "does not have a sign in link if the user is already signed in", points: 1 do
    visit "/"

    expect(page).to_not have_selector("a[href='/users/sign_in']"),
      "Expected home page to not have 'Sign in' link if the user is signed in."
  end
end

describe "The /users/edit page" do
  before do
    sign_in_user if user_model_exists?
  end

  it "can be visited", points: 1 do
    visit "/users/edit"

    expect(page.status_code).to be(200),
      "Expected to visit /users/edit successfully."
  end
end

describe "The /[USERNAME] user details page" do
  before do
    sign_in_user if user_model_exists?
  end

  it "can be visited", points: 1 do
    visit "/#{@user.username}"
    current_url = page.current_path

    expect(current_url).to eq("/#{@user.username}"),
      "Expected to visit the user details page at /[USERNAME] successfully."
  end

  it "has a link to Posts", points: 1 do
    visit "/#{@user.username}"

    expect(page).to have_selector("a[href='/#{@user.username}'][class='nav-link']", text: "Posts"),
      "Expected /[USERNAME] to have a link to 'Posts' with class='nav-link' that goes to /[USERNAME]."
  end

  it "has a link to Liked Photos", points: 1 do
    visit "/#{@user.username}"

    expect(page).to have_selector("a[href='/#{@user.username}/liked'][class='nav-link']", text: "Liked Photos"),
    "Expected /[USERNAME] to have a link to 'Liked Photos' with class='nav-link' that goes to /[USERNAME]/liked."
  end

  it "shows the photos on bootstrap cards", points: 1 do
    photo = Photo.create(image: "https://robohash.org/#{rand(9999)}", caption: "caption", owner_id: @user.id)

    visit "/#{@user.username}"

    expect(page).to have_selector("div[class='card']"),
      "Expected /[USERNAME] to have <div class='card'> elements to display the photos."
  end

  it "shows the comments under the photos on the bootstrap cards", points: 1 do
    photo = Photo.create(image: "https://robohash.org/#{rand(9999)}", caption: "caption", owner_id: @user.id)
    comment = Comment.create(body: "body", author_id: @user.id, photo_id: photo.id)

    visit "/#{@user.username}"

    expect(page).to have_selector("div[class='card'] ul[class^='list-group']", text: comment.body),
      "Expected /[USERNAME] to have <ul class='list-group...'> bootstrap list elements under the photos to display comments."
  end

  it "has a bootstrap styled 'Create Comment' button", points: 1 do
    photo = Photo.create(image: "https://robohash.org/#{rand(9999)}", caption: "caption", owner_id: @user.id)

    visit "/#{@user.username}"

    expect(page).to have_selector("input[class^='btn'][value='Create Comment']"),
      "Expected photo card to have <input value='Create Comment' class='btn...'> bootstrap styled 'Create Comment' button."
  end

  it "allows a signed in user to add a comment", points: 1 do
    photo = Photo.create(image: "https://robohash.org/#{rand(9999)}", caption: "caption", owner_id: @user.id)

    visit "/#{@user.username}"

    old_comments_count = Comment.count

    fill_in "Body", with: "New comment"
    click_button "Create Comment"

    new_comments_count = Comment.count

    expect(old_comments_count).to be < new_comments_count,
      "Expected to successfully create a new comment with the 'Body' comment field on a photo."
  end
end

describe "User authentication with the Devise gem" do
  let(:user) { User.create(username: "alice", email: "alice@example.com", password: "password") }

  it "allows a signed up user to sign in", points: 1 do
    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page.current_path).to eq("/"),
      "Expected to successfully sign in a signed up user."
  end

  it "requires sign in before any action with the Devise `before_action :authenticate_user!` method", points: 2 do
    visit "/#{user.username}"
    current_url = page.current_path

    expect(current_url).to eq(new_user_session_path),
      "Expected `before_action :authenticate_user!` in `ApplicationController` to redirect guest to /users/sign_in before visiting another page."
  end
end

def sign_in_user
  new_user = "alice_#{rand(100)}"
  @user = User.create(username: new_user, email: "#{new_user}@example.com", password: "password")
  visit new_user_session_path

  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Log in"

  return @user
end

def user_model_exists?
  Object.const_defined?("User")
end
