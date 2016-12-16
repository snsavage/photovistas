require 'spec_helper'

describe UnsplashController do
  # describe 'unsplash access token' do
  #   it 'regenerates a token with access to current user' do
  #     skip "Only use when testing extract process"
  #     unsplash_token_setup

  #     expect{Unsplash::User.current[:username]}.not_to raise_error
  #   end
  # end

  describe 'GET /unsplash/callback' do
    it 'redirects to /settings/:username' do
      user = create(:user)
      get "/unsplash/callback", {}, 'rack.session' => {user_id: user.id}

      expect(last_response.status).to eq(302)
      expect(last_response.location).to include("/settings/#{user.username}")
    end
  end

  describe 'GET /unsplash/unlink' do
    it 'removes unsplash token and username from db' do
      user = create(:user)
      user.unsplash_token = "temp"
      user.unsplash_username = "temp"
      user.save!

      get '/unsplash/unlink', {}, 'rack.session' => {user_id: user.id}

      unlinked = User.find(user.id)

      expect(unlinked.unsplash_token).to be nil
      expect(unlinked.unsplash_username).to be nil
      expect(last_response.location).to include("/settings/#{unlinked.username}")
    end
  end
end
