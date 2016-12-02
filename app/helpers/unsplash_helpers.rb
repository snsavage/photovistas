module UnsplashHelpers
  def unsplash_authorize(code)
    Unsplash::Client.connection.authorize!(code)
  end

  def unsplash_auth_from_db
    if current_user.unsplash_token?
      Unsplash::Client.connection.create_and_assign_token(current_user.unsplash_token)
    end
  end

  def unsplash_user
    if unsplash_auth_from_db
      @unsplash_user ||= Unsplash::User.current
    end
  end

  def unsplash_extract
    Unsplash::Client.connection.extract_token
  end

  def unsplash_save_token
    current_user.update(unsplash_token: unsplash_extract,
                        unsplash_username: Unsplash::User.current[:username])
  end
end
