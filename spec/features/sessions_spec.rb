require 'spec_helper'

feature 'user log in and log out', type: :feature do

  scenario 'user can login' do
    user = create(:user)
    visit '/'
    click_link 'Log in'

    fill_in('Username', with: user.username)
    fill_in('Password', with: user.password)
    click_button ('Log in') 

    expect(page.current_path).to include("/users/#{user.id}")
    expect(page.body).not_to include("Sign up")
    expect(page.body).not_to include("Log in")
    expect(page.body).to include("Log out")
  end
end

