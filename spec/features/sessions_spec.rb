require 'spec_helper'

feature 'sign up, log in, and log out', type: :feature do
  scenario 'guest user can visit signup page from homepage' do
    visit '/'
    click_link 'Sign up'
    expect(page.body).to include("Create an Account")
  end

  feature 'new user signup' do
    scenario 'with an unsplash username' do
      user = attributes_for(:user_with_unsplash)
      visit '/signup'
      fill_in('Username', with: user[:username])
      fill_in('Email', with: user[:email])
      fill_in('Password', with: user[:password])
      click_button ('Sign up')
      expect(page.current_path).to include("/signup/unsplash")

      fill_in('Unsplash Username', with: user[:unsplash_username])
      click_button ('Add username')
      expect(page.current_path).to include("/signup/photos")

      check('Amazing Landscapes')
      click_button ('Select photos')
      expect(page.current_path).to include("/users/")
      expect(page.body).to include("Welcome, #{user[:username]}!")
    end

    scenario 'without selecting photos' do
      user = attributes_for(:user_with_unsplash)
      visit '/signup'
      fill_in('Username', with: user[:username])
      fill_in('Email', with: user[:email])
      fill_in('Password', with: user[:password])
      click_button ('Sign up')
      expect(page.current_path).to include("/signup/unsplash")

      fill_in('Unsplash Username', with: user[:unsplash_username])
      click_button ('Add username')
      expect(page.current_path).to include("/signup/photos")

      click_button ('Skip')
      expect(page.current_path).to include("/users/")
      expect(page.body).to include("Welcome, #{user[:username]}!")
    end

    scenario 'without an unsplash username' do
      user = attributes_for(:user)
      visit '/signup'
      fill_in('Username', with: user[:username])
      fill_in('Email', with: user[:email])
      fill_in('Password', with: user[:password])
      click_button ('Sign up')
      expect(page.current_path).to include("/signup/unsplash")

      click_button ('Skip')
      expect(page.current_path).to include("/users/")
      expect(page.body).to include("Welcome, #{user[:username]}!")
    end
  end

  scenario 'after sign up user is logged in' do
    user = attributes_for(:user)
    visit 'signup'
    fill_in('Username', with: user[:username])
    fill_in('Email', with: user[:email])
    fill_in('Password', with: user[:password])
    click_button ('Sign up')

    expect(page.body).not_to include("Sign up")
    expect(page.body).not_to include("Log in")
    expect(page.body).to include("Log out")
  end

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

  scenario 'sign up form flash message should only flash once' do
    # skip "Issue resolved with use Rack::Flash, sweep: true"

    # Provide form with invalid input to trigger form errors flash.
    visit '/signup'
    click_button ('Sign up')
    expect(page.body).to include("Error:")

    # Return to site home page.
    click_link 'Vistas'
    expect(page.current_path).to include("/")

    # Go back to sign up page.
    click_link 'Sign up'
    expect(page.current_path).to include("/signup")
    expect(page.body).not_to include("Error:")
  end
end

