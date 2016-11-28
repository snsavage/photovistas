require 'spec_helper'

feature 'user signup', type: :feature do
  scenario 'guest user can signup' do
    visit '/'
    click_link 'Sign up'
    expect(page.body).to include("Create an Account")
  end

  scenario 'loggedin user cannot signup' do
    skip
  end
end

