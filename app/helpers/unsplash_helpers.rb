module UnsplashHelpers
  def unsplash_connection
    Unsplash::Client.connection
  end

  def unsplash_authorize(code)
    Unsplash::Client.connection.authorize!(code)
  end

  def unsplash_authorized?
    !!Unsplash::Client.connection.instance_variable_get(:@oauth_token)
  end

  def unsplash_auth_from_db
    if current_user.unsplash_token?
      Unsplash::Client.connection.create_and_assign_token(current_user.unsplash_token)
    end
  end

  def unsplash_user
    @unsplash_user ||= Unsplash::User.current if unsplash_auth_from_db
  end

  def unsplash_extract
    Unsplash::Client.connection.extract_token
  end

  def unsplash_save_token
    current_user.update(unsplash_token: unsplash_extract,
                        unsplash_username: unsplash_user[:username])
    current_user.save
  end
end