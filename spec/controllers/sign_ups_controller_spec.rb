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
end

describe 'unsplash access token' do
  it 'regenerates a token with access to current user' do
    unsplash_token
    expect(Unsplash::User.current[:username]).to eq("snsavage")
  end
end
