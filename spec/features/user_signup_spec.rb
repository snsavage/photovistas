require 'spec_helper'

feature 'user signup', type: :feature do
  scenario 'guest user can visit signup page from homepage' do
    visit '/'
    click_link 'Sign up'
    expect(page.body).to include("Create an Account")
  end

  scenario 'guest user can signup for new account' do
    user = attributes_for(:user)
    visit '/signup'
    fill_in('Username', with: user[:username])
    fill_in('Email', with: user[:email])
    fill_in('Password', with: user[:password])
    click_button ('Sign up')

    expect(page.body).to include("Welcome, #{user[:username]}!")
  end

  scenario 'loggedin user cannot signup' do
    skip
  end
end

