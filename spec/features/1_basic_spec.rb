require "rails_helper"

describe "/users/sign_in" do
  let(:user) { User.create(username: "alice", email: "alice@example.com", password: "password") }

  it "allows a user to sign in", points: 2 do
    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content("Signed in successfully."),
      "Expected to visit /users/sign_in, login with a signed up user, and be redirected to the homepage with a notification 'Signed in successfully.'."
  end
end
