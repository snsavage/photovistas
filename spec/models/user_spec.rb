require 'spec_helper'

describe User do
  it 'has secure password ' do
    user = build(:user)
    expect(user).to respond_to(:password_digest, :authenticate)
  end

  it 'has attribute unsplash_username' do
    user = build(:user)
    expect(user).to respond_to(:unsplash_username)
  end

  it 'has attribute unsplash_token' do
    user = build(:user)
    expect(user).to respond_to(:unsplash_token)
  end

  describe '#unsplash_token' do
    it 'can be serialized' do
      user = create(:user)
      user.update(unsplash_token: unsplash_token_setup)

      expect(user.unsplash_token).to be_a(Hash)
    end
  end

  describe 'validations' do
    describe '#username' do
      it 'must be present' do
        user = build(:user)
        user.username = nil
        expect(user).to be_invalid
      end

      it 'must be unique' do
        user = create(:user)
        dup_user = build(:user)

        dup_user.username = user.username
        expect(dup_user).to be_invalid
      end

      it 'must be at least 2 characters' do
        user = build(:user)
        user.username = "x"

        expect(user).to be_invalid
      end

      it 'must be no longer than 25 characters' do
        user = build(:user)
        user.username = 'x' * 26

        expect(user).to be_invalid
      end

      it 'must only include letters and numbers' do
        user = build(:user)
        user.username = "$$$"

        expect(user).to be_invalid
      end

      it 'must not have any spaces' do
        user = build(:user)
        user.username = " abc "

        expect(user).to be_invalid
      end
    end

    describe '#email' do
      it 'must be present' do
        user = build(:user)
        user.email = nil
        expect(user).to be_invalid
      end

      it 'must be unique' do
        user = create(:user)
        dup_user = build(:user)

        dup_user.email = user.email
        expect(dup_user).to be_invalid
      end
    end

    describe '#password' do
      it 'must be present' do
        user = build(:user)
        user.password = nil
        expect(user).to be_invalid
      end

      it 'must be present only on create' do
        id = create(:user).id
        user = User.find(id)
        user.username = "test"
        user.save!
        expect(user).to be_valid
      end

      it 'must be at least 8 characters' do
        user = build(:user)
        user.password = "x" * 7

        expect(user).to be_invalid
      end

      it 'must be no longer than 48 characters' do
        user = build(:user)
        user.password = "x" * 49

        expect(user).to be_invalid
      end
    end
  end
end

