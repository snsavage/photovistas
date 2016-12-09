require 'spec_helper'

describe QueueController do
  describe 'GET /queue/:username/edit' do
    context 'with a valid logged in user' do
      it 'renders /queue/:username/edit' do
        user = create(:user_with_unsplash)
        2.times { user.photos.create(attributes_for(:photo)) }

        get("/queue/#{user.username}/edit", {},
            'rack.session' => {user_id: user.id})

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Edit Your Queue")
      end
    end

    context 'with a logged out user' do
      it 'redirects to /' do
        user = create(:user_with_unsplash)

        get("/queue/#{user.username}/edit")

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'with an invalid user' do
      it 'redirects to /' do
        user = create(:user_with_unsplash)
        invalid = create(:user)

        get("/queue/#{user.username}/edit", {},
            'rack.session' => {user_id: invalid.id})

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end

  describe 'PATCH /queue/:username' do
    context 'with a valid logged in user' do
      it 'removes items from user queue' do
        user = create(:user_with_unsplash)
        2.times { user.photos.create(attributes_for(:photo)) }

        {queue: [] << user.photo_queues.first.id}

        expect{
          patch(
            "/queue/#{user.username}",
            {queue: [] << user.photo_queues.first.id},
              'rack.session' => {user_id: user.id}
          )
        }.to change{user.photo_queues.count}.by(-1)

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")
      end
    end

    context 'with an invalid user' do
      it 'redirects to /' do
        user = create(:user_with_unsplash)
        invalid = create(:user_with_unsplash)

        2.times { user.photos.create(attributes_for(:photo)) }

        {queue: [] << user.photo_queues.first.id}

        expect{
          patch(
            "/queue/#{user.username}",
            {queue: [] << user.photo_queues.first.id},
              'rack.session' => {user_id: invalid.id}
          )
        }.not_to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include(root_path)
      end
    end

    context 'with an invalid user' do
      it 'redirects to /' do
        user = create(:user_with_unsplash)

        2.times { user.photos.create(attributes_for(:photo)) }

        {queue: [] << user.photo_queues.first.id}

        expect{
          patch(
            "/queue/#{user.username}",
            {queue: [] << user.photo_queues.first.id}
          )
        }.not_to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include(root_path)
      end
    end
  end

  describe 'POST /queue/:username' do
    context 'with a liked param' do
      it 'adds liked photos to queue', vcr: {record: :once} do
        user = create(:user_with_unsplash)

        expect{
        post("/queue/#{user.username}",
             params = {collections: "liked"},
             'rack.session' => {user_id: user.id})
        }.to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")

        follow_redirect!
        expect(last_response.body).to include("Your Queue has been updated.")
      end
    end

    context 'with a collection param' do
      it 'adds collection photos to queue', vcr: {record: :once} do
        user = create(:user_with_unsplash)

        expect{
        post("/queue/#{user.username}",
             params = {collections: "447805"},
             'rack.session' => {user_id: user.id})
        }.to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")

        follow_redirect!
        expect(last_response.body).to include("Your Queue has been updated.")
      end
    end
    context 'with the wrong user' do
      it 'redirects to /settings/:username' do
        user = create(:user_with_unsplash)
        invalid = create(:user_with_unsplash)

        expect{
        post("/queue/#{user.username}",
             params = {collections: "liked"},
             'rack.session' => {user_id: invalid.id})
        }.not_to change{invalid.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'with a logged out user' do
      it 'redirects to /' do
        user = create(:user_with_unsplash)

        expect{
        post("/queue/#{user.username}",
             params = {collections: "liked"})
        }.not_to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'when a user does not have an unsplash account' do
      it 'redirects to /' do
        user = create(:user)

        expect{
        post("/queue/#{user.username}",
             params = {collections: "liked"},
             'rack.session' => {user_id: user.id})
        }.not_to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")
      end
    end
  end

  describe 'DELETE /queue/:username' do
    context 'with valid user' do
      it 'removes all photos in queue' do
        user = create(:user)
        2.times { user.photos.create(attributes_for(:photo)) }

        expect{
          delete("/queue/#{user.username}",
                 {},
                 'rack.session' => {user_id: user.id})
        }.to change{user.photo_queues.count}.by(-2)

        expect(last_response.status).to eq(302)
        expect(last_response.location).to include("/settings/#{user.username}")
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to / and the queue does not change' do
        user = create(:user)
        2.times { user.photos.create(attributes_for(:photo)) }

        expect{
          delete("/queue/#{user.username}")
        }.not_to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end

    context 'with an invalid user' do
      it 'redirects to / and the queue does not change' do
        user = create(:user)
        invalid = create(:user)

        2.times { user.photos.create(attributes_for(:photo)) }

        expect{
          delete("/queue/#{user.username}",
                 {},
                 'rack.session' => {user_id: invalid.id})
        }.not_to change{user.photo_queues.count}

        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(root_path)
      end
    end
  end
end

