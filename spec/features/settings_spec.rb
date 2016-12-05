require 'spec_helper'

vcr_options = {record: :once}

feature 'user settings', :feature do
  context 'with an unsplash usersname' do
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

      expect(page.body).to include("Unlink Unsplash Account")
      expect(page.body).to include("/unsplash/unlink")
    end

    scenario 'user can add likes to queue', vcr: vcr_options do
      skip
      user = create(:user_with_unsplash)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')

      beg_count = user.queue.count
      clink_link("Add Photos to Queue")

      photos_added = user.queue.count - beg_count

      expect(page.body).to include("#{photos_added} have been added to your queue!")
    end
  end

  context 'without an unsplash username' do
    scenario 'user can view account settings' do
      user = create(:user)
      visit '/login'
      fill_in('username', with: user.username)
      fill_in('password', with: user.password)
      click_button ('Log in')


      expect(page.body).to include("Photo Vistas Account Settings")
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

      expect(page.body).to include("Link Unsplash Account")
      expect(page.body).to include("/unsplash/auth")
    end

    scenario 'user can change user settings' do
      skip
    end

    scenario 'user has access to the default photo queue' do
      skip
    end

    scenario 'user has a time zone' do
      skip
    end
  end
end

