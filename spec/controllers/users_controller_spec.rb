require 'spec_helper'

def login
  user = create(:user)
  post '/login', {username: user.username, password: user.password}
  return user
end

def root_path
  "http://example.org/"
end

describe UsersController do
  describe 'GET /signup' do
    context 'with a new user' do
      it 'renders sign up page' do
        get '/signup'
        expect(last_response.status).to eq(200)
      end
    end

    context 'with a logged in user' do
      it 'redirects to /' do
        user = create(:user)
        post '/login', {username: user.username, password: user.password}

        get '/signup'
        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'GET /login' do
    context 'when user not logged in' do
      it 'renders /users/login' do
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
        expect(last_response.location).to include("/users/#{user.id}")
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

  describe 'GET /users/:id' do
    context 'with valid logged in user' do
      it 'returns user page' do
        user = login
        get "/users/#{user.id}"

        expect(last_response.status).to eq(200)
      end
    end

    context 'with invalid user' do
      it 'redirects to /' do
        get "/users/100"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'when a user requests wrong account' do
      it 'redirects to /' do
        other_user_id = create(:user).id
        user = login
        get "/users/#{other_user_id}"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'when a guest requests a user account' do
      it 'redirects to /' do
        user = create(:user)
        get "/users/#{user.id}"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'POST /users' do
    context 'with valid input' do
      let(:params) { attributes_for(:user) }

      it 'creates new user' do
        expect{ post '/users', params }.to change{ User.count }.by(1)
      end

      it 'redirects to /users/:id' do
        post '/users', params
        user = User.first

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/users/#{user.id}")
      end

      it 'add user.id to session[:user_id]' do
        post '/users', params
        user = User.first
        session = last_request.env['rack.session']
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid input' do
      it 'renders view users/new' do
        post '/users'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Create an Account")
      end

      it 'flashes error message' do
        post '/users'
        expect(last_response.body).to include('Error')
      end
    end

    context 'when user logged in' do
      it 'redirects to /' do
        user = login
        post '/users', attributes_for(:user)

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end
end
