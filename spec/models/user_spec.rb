require 'spec_helper'

describe User do
  describe '#current_photo' do
    it 'finds a photo_queue without a last_viewed date' do
      Timecop.freeze(Date.today)

      user = create(:user)
      2.times do
        user.photos << create(:photo)
      end

      expect{Timecop.freeze(Date.tomorrow)}.to change{user.current_photo.id}
    end

    it "adds today's date to the photo queue last_viewed" do
      Timecop.freeze(Date.today)

      user = create(:user)
      2.times do
        user.photos << create(:photo)
      end

      photo = user.current_photo

      expect(
        user.photo_queues.find_by(photo_id: photo.id).last_viewed
      ).to eq(Date.today)
    end

    context 'when a photo_queue has already been set for today' do
      it 'finds todays photo queue' do
        Timecop.freeze(Date.today)

        user = create(:user)
        2.times do
          user.photos << create(:photo)
        end

        todays_photo = user.current_photo
        second_request = User.find(user.id)

        expect(todays_photo.id).to eq(second_request.current_photo.id)
      end
    end

    context "when all photo_queues have a last_viewed date" do
      it 'no queues will have a null last_viewed date' do
        Timecop.freeze(Date.today)

        user = create(:user)
        2.times do
          user.photos << create(:photo)
        end

        todays_photo = user.current_photo

        Timecop.freeze(Date.tomorrow)
        tomorrows_photo = user.current_photo

        expect(user.photo_queues.where("last_viewed IS NULL").count).to eq(0)
      end

      it 'finds the oldest last_viewed queue' do
        Timecop.freeze(Date.today)

        user = create(:user)

        2.times do
          user.photos << create(:photo)
        end

        todays_photo = user.current_photo

        Timecop.freeze(Date.tomorrow)
        user = User.find(user.id)
        tomorrows_photo = user.current_photo

        Timecop.freeze(Date.tomorrow)
        user = User.find(user.id)
        expect(user.current_photo.id).to eq(todays_photo.id)

        Timecop.freeze(Date.tomorrow)
        user = User.find(user.id)
        expect(user.current_photo.id).to eq(tomorrows_photo.id)
      end
    end
  end

  describe '#add_photos_to_queue' do
    it 'does not add nil records' do
      user = create(:user)

      expect{
        user.add_photos_to_queue(nil)
      }.not_to change{user.photo_queues.count}
    end

    it 'controls for duplications and validation errors' do
      user = create(:user)
      photos = 10.times.map do |x|
        {unsplash_id: "unsplash_#{x}"}
      end

      user.add_photos_to_queue(photos)

      to_destroy = user.photo_queues.first(3)

      expect{
        user.photo_queues.destroy(to_destroy)
      }.to change{user.photo_queues.count}.by(-3)

      expect{
        user.add_photos_to_queue(photos)
      }.to change{user.photo_queues.count}.by(3)
    end
  end

  it 'has many photos' do
    user = create(:user)
    user.photos << create(:photo) << create(:photo)

    expect(user.photos.count).to eq(2)
  end

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

