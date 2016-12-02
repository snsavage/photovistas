require 'spec_helper'

feature 'user sign up', type: :feature do
  scenario 'guest user can visit signup page from homepage' do
    visit '/'
    click_link 'Sign Up'
    expect(page.body).to include("Create an Account")
  end

  feature 'new user signup' do
    scenario 'with an unsplash account' do
      skip "This test requires the development server to be running."
      Capybara.current_driver = :selenium

      user = attributes_for(:user_with_unsplash)
      visit '/signup'
      fill_in('username', with: user[:username])
      fill_in('email', with: user[:email])
      fill_in('password', with: user[:password])
      fill_in('confirm', with: user[:password])
      check("unsplash")
      click_button ('Sign Up')

      fill_in('user_email', with: "effie.fay@okeefe.info")
      fill_in('user_password', with: "omnis79")
      click_button ('Login')

      # Only needed if test user has been used before.
      # click_button ('Authorize')

      expect(page.current_url).to include("/unsplash/callback?code=")
    end

    scenario 'without an unsplash account' do
      user = attributes_for(:user)
      visit '/signup'
      fill_in('Username', with: user[:username])
      fill_in('Email', with: user[:email])
      fill_in('password', with: user[:password])
      fill_in('confirm', with: user[:password])
      click_button ('Sign Up')

      expect(page.current_path).to include("/settings")
      expect(page.body).to include("Add an Unsplash Username")
    end
  end

  scenario 'after sign up user is logged in' do
    user = attributes_for(:user)
    visit 'signup'
    fill_in('Username', with: user[:username])
    fill_in('Email', with: user[:email])
    fill_in('password', with: user[:password])
    fill_in('confirm', with: user[:password])
    click_button ('Sign Up')

    expect(page.body).not_to include("Sign Up")
    expect(page.body).not_to include("Log in")
    expect(page.body).to include("Log out")
  end

  scenario 'user can log in' do
    user = create(:user)
    visit "/login"
    fill_in('Username', with: user.username)
    fill_in('Password', with: user.password)
    click_button ('Log in')

    expect(page.body).not_to include("Sign Up")
    expect(page.body).not_to include("Log in")
    expect(page.body).to include("Log out")
  end


  scenario 'sign up form flash message should only flash once' do
    # skip "Issue resolved with use Rack::Flash, sweep: true"

    # Provide form with invalid input to trigger form errors flash.
    visit '/signup'
    click_button ('Sign Up')
    expect(page.body).to include("Error:")

    # Return to site home page.
    click_link 'Vistas'
    expect(page.current_path).to include("/")

    # Go back to sign up page.
    click_link 'Sign Up'
    expect(page.current_path).to include("/signup")
    expect(page.body).not_to include("Error:")
  end
end

