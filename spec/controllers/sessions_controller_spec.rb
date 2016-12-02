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
      it 'renders /users/:id' do
        user = create(:user)
        post '/login', {username: user.username, password: user.password}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings")
      end
    end

    context 'with invalid credentials' do
      it 'renders /login' do
        post '/login'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('<h2>Login</h2>')
      end

      it 'flashes error message' do
        post '/login'
        expect(last_response.body).to include('Error: ')
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
