require "rails_helper"

describe "User authentication with the Devise gem" do
  let(:user) { User.create(username: "alice", email: "alice@example.com", password: "password") }

  it "requires sign in before any action with the Devise `before_action :authenticate_user!` method", points: 2 do
    visit "/#{user.username}"
    current_url = page.current_path

    expect(current_url).to eq(new_user_session_path),
      "Expected `before_action :authenticate_user!` in `ApplicationController` to redirect guest to /users/sign_in before visiting another page."
  end
end

def sign_in_user
  user = User.create(username: "alice", email: "alice@example.com", password: "password")
  visit new_user_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

def user_model_exists?
  Object.const_defined?("User")
end
