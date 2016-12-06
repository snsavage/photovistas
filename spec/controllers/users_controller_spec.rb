require 'spec_helper'

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
        get '/signup', {}, 'rack.session' => {user_id: user.id}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'POST /signup' do
    context 'with valid input' do
      let(:params) { {credentials: attributes_for(:user) } }

      it 'creates new user' do
        expect{ post '/signup', params }.to change{ User.count }.by(1)
      end

      it 'adds user.id to session[:user_id]' do
        post '/signup', params
        user = User.first
        session = last_request.env['rack.session']
        expect(session[:user_id]).to eq(user.id)
      end

      context 'when user wants to add unsplash account' do
        it 'redirects to /unsplash/auth' do
          params[:unsplash] = "unsplash"
          post '/signup', params

          expect(last_response.status).to eq(302)
          expect(last_response.location).to include("/unsplash/auth")
        end
      end
    end

    context 'with invalid input' do
      it 'renders view signup/new' do
        post '/signup'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Create an Account")
      end

      it 'flashes error message' do
        post '/signup'
        expect(last_response.body).to include('Error')
      end
    end

    context 'when user logged in' do
      it 'redirects to /' do
        user = login
        post '/signup', attributes_for(:user)

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'GET /settings/:username' do
    context 'with valid logged in user' do
      it 'renders user page' do
        user = create(:user)
        get "/settings/#{user.username}", {}, 'rack.session' => {user_id: user.id}

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Account Settings")
      end
    end

    context 'with invalid user' do
      it 'redirects to /' do
        get "/settings/invalid"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'when a user has an unsplash account' do
      it 'displays unsplash username', :vcr do
        user = create(:user_with_unsplash)

        get "/settings/#{user.username}", {}, 'rack.session' => {user_id: user.id}

        expect(last_response.body).to include("Unsplash Username")
      end

      it 'displays link to remove unsplash account' do
      end
    end
  end

  describe 'GET /settings/:username/edit' do
    context 'when logged in' do
      it 'renders the edit user form' do
        user = create(:user)
        get "/settings/#{user.username}/edit", {}, 'rack.session' => {user_id: user.id}

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Edit Account Settings")
      end

      it 'pre fills form fields' do
        user = create(:user)
        get "/settings/#{user.username}/edit", {}, 'rack.session' => {user_id: user.id}

        expect(last_response.body).to include(user.username)
        expect(last_response.body).to include(user.email)
      end
    end

    context 'with an invalid user' do
      it 'redirects to /' do
        user = create(:user)
        invalid = create(:user)
        get "/settings/#{user.username}/edit", {}, 'rack.session' => {user_id: invalid.id}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include(root_path)
      end
    end

    context 'when not logged in' do
      it 'redirects to /' do
        get "/settings/invalid/edit"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include(root_path)
      end
    end
  end

  describe 'PATCH /settings/:username' do
    context 'with valid changes' do
      it 'redirects to /settings/:username' do
        user = create(:user)
        params = {
          credentials: {
            username: "username",
            email: "newemail@example.org"
          }
        }

        patch("/settings/#{user.username}", params,
              'rack.session' => {user_id: user.id})

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include(
          "/settings/#{params[:credentials][:username]}"
        )
      end

      it 'updates account settings' do
        user = create(:user)
        params = {
          credentials: {
            username: "username",
            email: "newemail@example.org"
          }
        }

        patch("/settings/#{user.username}", params,
              'rack.session' => {user_id: user.id})

        user = User.find(user.id)

        expect(user.username).to eq(params[:credentials][:username])
        expect(user.email).to eq(params[:credentials][:email])
      end

      it 'changes the password' do
        user = create(:user)
        params = {
          current: user.password,
          credentials: {
            password: "New Password",
            password_confirmation: "New Password"
          }
        }

        digest = user.password_digest

        patch("/settings/#{user.username}", params,
             'rack.session' => {user_id: user.id})

        user = User.find(user.id)
        expect(digest).not_to eq(user.password_digest)
      end
    end

    context 'when user does not provide current password' do
      it 'flashes error message' do
        user = create(:user)
        params = {
          credentials: {
            password: "New Password",
            password_confirmation: "New Password"
          }
        }

        patch("/settings/#{user.username}", params,
              'rack.session' => {user_id: user.id})

        expect(last_response.body).to include("Error: Please provide your current password to change passwords.")
      end
    end

    context 'with invalid changes' do
      it 'flashes error message' do
        user = create(:user)
        params = {credentials: {username: "$$$"}}

        patch("/settings/#{user.username}", params,
              'rack.session' => {user_id: user.id})

        expect(last_response.body).to include("Error: ")
        expect(last_response.body).not_to include("provide your current password")
      end

      it 'shows the user previous entries' do
        user = create(:user)
        params = {credentials: {username: "$$$"}}

        patch("/settings/#{user.username}", params,
              'rack.session' => {user_id: user.id})

        expect(last_response.body).to include(params[:credentials][:username])
      end
    end

    context 'when a user is logged out' do
      it 'redirects to /' do
        user = create(:user)
        patch "/settings/#{user.username}"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'with an invalid user' do
      it 'redirects to/' do
        user = create(:user)
        invalid = create(:user)

        patch("/settings/#{user.username}", {},
              'rack.session' => {user_id: invalid.id})

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end
end

