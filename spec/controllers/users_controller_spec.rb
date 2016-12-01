require 'spec_helper'

describe UsersController do
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
end

