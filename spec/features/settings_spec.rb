require 'spec_helper'

vcr_options = {record: :once}

feature 'user settings', :feature do
  context 'with an unsplash usersname' do
    scenario 'manage queue', vcr: {record: :new_episodes} do
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      expect{
        within(".unsplash-collection-photos") do
          click_button('Add to Queue', match: :first)
        end
      }.to change{user.photo_queues.count}

      click_link('Open Queue')

      check("queue1", match: :first)

      expect{
        click_button("Update Queue", match: :first)
      }.to change{user.photo_queues.count}.by(-1)

      expect{
        within(".unsplash-liked-photos") { click_button ('Add to Queue') }
      }.to change{user.photo_queues.count}
    end

    scenario 'shows likes', vcr: vcr_options do
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      Unsplash::Client.connection.create_and_assign_token(user.unsplash_token)
      all_likes = Unsplash::User.current.likes

      links = all_likes.first(2).map do |like|
        {id: like.urls.raw, thumb: like.urls.thumb}
      end

      username = Unsplash::User.current.username

      expect(page.body).to include("Total: #{all_likes.count}")
      expect(page.body).to include(links[0][:id])
      expect(page.body).to include(links[1][:id])
      expect(page.body).to include(links[0][:thumb])
      expect(page.body).to include(links[1][:thumb])
      expect(page.body).to include("https://unsplash.com/@#{username}/likes")
    end

    scenario 'shows collections', vcr: vcr_options do
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      Unsplash::Client.connection.create_and_assign_token(user.unsplash_token)
      collections = Unsplash::User.current.collections.map do |collection|
        {
          title:  collection.title,
          id:     collection.id,
          count:  collection.total_photos,
          photos: collection.photos.first(5)
        }
      end

      expect(page.body).to include(collections[0][:title])
      expect(page.body).to include(collections[1][:title])

      expect(page.body).to include(collections[0][:photos].first.urls.thumb)
      expect(page.body).to include(collections[1][:photos].first.urls.thumb)

    end

    scenario 'user can unlink an unsplash account', vcr: vcr_options do
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      expect(page.body).to include("<button>Unlink</button>")
      expect(page.body).to include("/unsplash/unlink")
    end

    scenario 'user can add likes to queue', :vcr do
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      within(".unsplash-liked-photos") do
        click_button("Add to Queue")
      end

      expect(page.body).to include("Your Queue has been updated.")
    end

    scenario 'user can add a collection to queue', vcr: {record: :new_episodes} do
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      within(".unsplash-collection-photos") do
        click_button("Add to Queue", match: :first)
      end

      expect(page.body).to include("Your Queue has been updated.")
    end
  end

  context 'without an unsplash username' do
    scenario 'user can view account settings' do
      user = create(:user)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')


      expect(page.body).to include("Photo Vistas Settings")
      expect(page.body).to include("Username: #{user.username}")
      expect(page.body).to include("Email: #{user.email}")
      # expect(page.body).to include("Time Zone: #{user.timezone}")
      expect(page.body).to include("Edit Account Settings")
    end

    scenario 'user can link an unsplash account' do
      user = create(:user)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      expect(page.body).to include("Link")
      expect(page.body).to include("/unsplash/auth")
    end

    scenario 'user can change user settings' do
      user = create(:user)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      click_link('Edit Account Settings')
      fill_in('username', with: "New Username")
      fill_in('email', with: "newemail@example.org")

      fill_in('Current Password', with: user.password)
      fill_in('New Password', with: "new password")
      fill_in('Password Confirmation', with: "new password")

      click_button("Save Changes")

      expect(page.body).to include("New Username")
      expect(page.body).to include("newemail@example.org")
    end

    scenario 'user has access to the default photo queue' do
      skip
    end

    scenario 'user has a time zone' do
      skip
    end
  end
end

