require 'spec_helper'

describe UsersController do
  describe 'GET /settings' do
    context 'with valid logged in user' do
      it 'renders user page' do
        user = create(:user)
        get "/settings", {}, 'rack.session' => {user_id: user.id}

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Account Settings")
      end
    end

    context 'with invalid user' do
      it 'redirects to /' do
        get "/settings"

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'when a user has an unsplash account' do
      it 'displays unsplash username' do
        user = create(:user_with_unsplash)

        get "/settings", {}, 'rack.session' => {user_id: user.id}

        expect(last_response.body).to include("Unsplash Username")
      end

      it 'displays link to remove unsplash account' do
      end
    end
  end
end

