require 'spec_helper'

describe UnsplashController do
  describe 'unsplash access token' do
    it 'regenerates a token with access to current user' do
      # skip "Only use when testing extract process"
      unsplash_token_setup
      expect(Unsplash::User.current[:username]).to eq("snsavage")
    end
  end

  describe 'GET /unsplash/unlink' do
    it 'removes unsplash token and username from db' do
      user = create(:user)
      user.unsplash_token = "temp"
      user.unsplash_username = "temp"
      user.save!

      get '/unsplash/unlink', {}, 'rack.session' => {user_id: user.id}

      unlinked_user = User.find(user.id)

      expect(unlinked_user.unsplash_token).to be nil
      expect(unlinked_user.unsplash_username).to be nil
    end
  end
end
