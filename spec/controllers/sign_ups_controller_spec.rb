require 'spec_helper'

describe SignUpsController do
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
      let(:params) { attributes_for(:user) }

      it 'creates new user' do
        expect{ post '/signup', params }.to change{ User.count }.by(1)
      end

      it 'adds user.id to session[:user_id]' do
        post '/signup', params
        user = User.first
        session = last_request.env['rack.session']
        expect(session[:user_id]).to eq(user.id)
      end

      it 'adds step to session[:step]' do
        post '/signup', params
        session = last_request.env['rack.session']
        expect(session[:step]).to eq("1")
      end

      it 'redirects to /signup/unsplash' do
        post '/signup', params
        expect(last_response.location).to include("/signup/unsplash")

        follow_redirect!
        expect(last_response.status).to eq(200)
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

  describe 'GET /signup/unplash' do
    context 'after completing sign up step 1' do
      it 'renders /signup/unsplash' do
        params = attributes_for(:user_with_unsplash)
        unsplash_username = params.extract!(:unsplash_username)
        post '/signup', params
        follow_redirect!

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Unsplash Username")
      end
    end

    context 'when user not logged_in?' do
      it 'redirects to /' do
        get '/signup/unsplash'

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'without step key' do
      it 'redirects to /users/:id' do
        user = login
        get '/signup/unsplash'

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/users/#{user.id}")
      end
    end
  end

  describe 'POST /signup/unplash' do
    context 'when user has completed sign up step 1' do
      context 'when user wants to add username' do
        it 'renders /signup/photos' do
          user = create(:user)
          session = {user_id: user.id, step: "1"}
          params = {unsplash_username: "snsavage", add_username: "Add username"}

          post '/signup/unsplash', params, 'rack.session' => session

          user = User.find(user.id)

          expect(user.unsplash_username).to eq(params[:unsplash_username])
          expect(last_response.status).to eq(302)
          expect(last_response.location).to include("/signup/photos")
        end

        it 'adds step to session[:step]' do
          user = create(:user)
          session = {user_id: user.id, step: "1"}
          params = {unsplash_username: "snsavage", add_username: "Add username"}

          post '/signup/unsplash', params, 'rack.session' => session

          user = User.find(user.id)

          expect(last_request.env['rack.session'][:step]).to eq("2")
        end
      end

      context 'when user wants to skip step' do
        it 'redirects to /users/:id' do
          user = create(:user)
          session = {user_id: user.id, step: "1"}
          params = {unsplash_username: "snsavage", skip: "Skip"}

          post '/signup/unsplash', params, 'rack.session' => session

          user = User.find(user.id)

          expect(user.unsplash_username).to be nil
          expect(last_response.status).to eq(302)
          expect(last_response.location).to include("/users/#{user.id}")
        end

        it 'removes step to session[:step]' do
          user = create(:user)
          session = {user_id: user.id, step: "1"}
          params = {unsplash_username: "snsavage", skip: "Skip"}

          post '/signup/unsplash', params, 'rack.session' => session

          user = User.find(user.id)

          expect(last_request.env['rack.session'][:step]).to eq("")
        end
      end
    end

    context ' has not completed sign up step 1' do
      it 'redirect to /' do
        post '/signup/unsplash'

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'GET /signup/photos' do
    context 'after completing sign up step 2' do
      it 'renders /signup/photos' do
        user = create(:user_with_unsplash)
        session = {user_id: user.id, step: "2"}
        get '/signup/photos'#, {}, 'rack.session' => session

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Select Photos')
      end

      it 'handles Unsplash::Error on user lookup' do
      end

      it 'lists photo selections' do
        user = create(:user_with_unsplash)
        session = {user_id: user.id, step: "2"}

        get '/signup/photos', {}, 'rack.session' => session

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Amazing Landscapes')
        expect(last_response.body).to include('Likes Photos')
      end
    end

    context 'when user not logged_in?' do
      it 'redirects to /' do
        skip
      end
    end

    context 'without step key' do
      it 'redirects to /users/:id' do
        skip
      end
    end
  end
end
