require 'spec_helper'

describe QueueController do
  describe 'PATCH /queue/:username' do
    it 'removes items from user queue' do
      skip
    end
  end

  describe 'POST /queue/:username' do
    context 'with a liked param' do
      it 'adds liked photos to queue', vcr: {record: :once} do
        user = create(:user_with_unsplash)

        post("/queue/#{user.username}",
             params = {collections: "liked"},
             'rack.session' => {user_id: user.id})

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")

        follow_redirect!
        expect(last_response.body).to include("Your Queue has been updated.")
      end
    end

    context 'with a collection param' do
      it 'adds photo collection to queue', vcr: {record: :once} do
        user = create(:user_with_unsplash)

        post("/queue/#{user.username}",
             params = {collections: "447805"},
             'rack.session' => {user_id: user.id})

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")

        follow_redirect!
        expect(last_response.body).to include("Your Queue has been updated.")
      end
    end

    context 'with the wrong user' do
      it 'redirects to /settings/:username' do
        skip
      end
    end

    context 'with a logged out user' do
      it 'redirects to /' do
        skip
      end
    end
  end
end

