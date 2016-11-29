require 'spec_helper'

describe UsersController do
  it 'loads a sign up page' do
    get '/signup'
    expect(last_response.status).to eq(200)
  end

  it 'sign up directs a new user to the user settings page' do
    params = attributes_for(:user)
    post '/users', params

    user = User.first

    expect(last_response.location).to include("/users/#{user.id}")
  end

  it 'invalid sign up renders the signup page with a flash message' do
    post '/users'
    expect(last_response.body).to include('Error')
  end
end
