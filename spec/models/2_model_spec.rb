require "rails_helper"

describe "New User record" do
  it "has a default `likes_count` of 0", points: 1 do
    likes_count_column = User.column_for_attribute(:likes_count)

    expect(likes_count_column.default).to eq("0"),
      "Expected a new User to have a default `likes_count` of 0. Did you make the change in your User migration file?"
  end

  it "has a default `comments_count` of 0", points: 1 do
    comments_count_column = User.column_for_attribute(:comments_count)

    expect(comments_count_column.default).to eq("0"),
      "Expected a new User to have a default `comments_count` of 0. Did you make the change in your User migration file?"
  end
end
