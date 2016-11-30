require 'spec_helper'

class Helpers
  include SessionHelpers
  attr_accessor :session
  def initialize(session = {}) @session = session end
end

describe 'SessionHelpers' do
  let(:session) { {} }

  describe '#current_user' do
    context 'with valid user id' do
      it 'returns current user' do
        user = create(:user)
        session[:user_id] = user.id

        expect(Helpers.new(session).current_user.id).to eq(user.id)
      end
    end

    context 'with no session' do
      it 'returns nil' do
        expect(Helpers.new.current_user).to be nil
      end
    end

    context 'with invalid user id' do
      it 'returns nil' do
        session[:user_id] = 100

        expect(Helpers.new(session).current_user).to be nil
      end
    end
  end

  describe '#logged_in?' do
    context 'when user logged in' do
      it 'returns true' do
        user = create(:user)
        session[:user_id] = user.id

        expect(Helpers.new(session).logged_in?).to be true
      end
    end

    context 'when user not logged in' do
      it 'returns false' do
        expect(Helpers.new.logged_in?).to be false
      end
    end
  end
end

