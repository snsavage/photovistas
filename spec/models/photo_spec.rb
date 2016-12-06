require 'spec_helper'

describe Photo do
  it 'has many users' do
    user_one = create(:user)
    user_two = create(:user)

    photo = create(:photo)
    photo.users << user_one << user_two

    expect(photo.users.count).to eq(2)
  end
end
