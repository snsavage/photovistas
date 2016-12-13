require 'spec_helper'

describe SessionsController do
  describe 'GET /login' do
    context 'when user not logged in' do
      it 'renders /session/login' do
        get '/login'
        expect(last_response.status).to eq(200)
      end
    end

    context 'when user logged in' do
      it 'redirects to /' do
        user = create(:user)
        post '/login', {username: user.username, password: user.password}

        get '/login'

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'renders /settings/:username' do
        user = create(:user)
        post '/login', {username: user.username, password: user.password}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")
      end
    end

    context 'with invalid credentials' do
      it 'renders /login' do
        post '/login'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('<h1>Photo Vistas Log in</h1>')
      end

      it 'flashes error message' do
        post '/login'
        expect(last_response.body).to include('Please provide a valid username and password.')
      end
    end

    context 'when user logged in' do
      it 'redirects to /' do
        login
        post '/login'
        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'GET /logout' do
    context 'when user logged in' do
      it 'redirects to /login' do
        user = create(:user)
        post '/login', {username: user.username, password: user.password}
        follow_redirect!

        get '/logout'
        expect(last_response.location).to include('/login')

        follow_redirect!
        expect(last_response.body).not_to include('Log out')
      end
    end

    context 'when user not logged in' do
      it 'redirects to /' do
        get '/logout'
        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

end
