require 'spec_helper'

feature 'user signup', type: :feature do
  scenario 'guest user can signup' do
    visit '/'
    expect(page.body).to include("Vistas")
  end
end

