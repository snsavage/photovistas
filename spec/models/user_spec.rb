require 'spec_helper'

describe User do
  describe 'attributes' do
    it 'creates a valid User' do
      user = create(:user)
      expect(user).to be_valid
    end

    it 'requires a username' do
      user = build(:user)
      user.username = nil
      expect(user).to be_invalid
    end

    it 'requires a email' do
      user = build(:user)
      user.email = nil
      expect(user).to be_invalid
    end

    it 'requires a password' do
      user = build(:user)
      user.password = nil
      expect(user).to be_invalid
    end

    it 'username must be unique' do
      user = create(:user)
      dup_user = build(:user)

      dup_user.username = user.username
      expect(dup_user).to be_invalid
    end

    it 'email must be unique' do
      user = create(:user)
      dup_user = build(:user)

      dup_user.email = user.email
      expect(dup_user).to be_invalid
    end

    it 'username must be at least 2 characters long' do
      user = build(:user)
      user.username = "x"

      expect(user).to be_invalid
    end

    it 'username cannot be longer than 25 characters' do
      user = build(:user)
      user.username = 'x' * 26

      expect(user).to be_invalid
    end

    it 'password must be at least 8 characters long' do
      user = build(:user)
      user.password = "x" * 7

      expect(user).to be_invalid
    end

    it 'password must be no longer than 48 characters' do
      user = build(:user)
      user.password = "x" * 49

      expect(user).to be_invalid
    end
  end
end
