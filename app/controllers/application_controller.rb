require 'sinatra/base'
require 'sinatra/asset_pipeline'

class ApplicationController < Sinatra::Base
  set :assets_paths, %w(./../assets/stylesheets ./../assets/images)
  set :assets_precompile, %w(app.js app.css bookmark.css clear.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)

  register Sinatra::AssetPipeline

  helpers SessionHelpers
  helpers UnsplashHelpers
  helpers ParamHelpers
  helpers TimeZoneHelpers
  helpers Sprockets::Helpers

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  if production?
    use Rack::Session::Cookie,
      :key => 'rack.session',
      :domain => 'photovistas.com',
      :path => '/',
      :expire_after => 2592000, # In seconds
      :secret => ENV['SESSION_SECRET']

    use Rack::SSL
    use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
  end

  if !production?
    use Rack::Session::Cookie,
      :expire_after => 2592000, # In seconds
      :secret => ENV['SESSION_SECRET']
  end

  use Rack::Flash, sweep: true

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  configure :production, :development do
    enable :logging
  end

  get '/' do
    erb :index, locals: {clear: true}
  end

  get '/contact' do
    erb :contact
  end

  get '/help' do
    erb :help
  end
end

