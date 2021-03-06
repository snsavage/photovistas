ENV["RACK_ENV"] ||= "development"

require 'sinatra/activerecord/rake'
require 'sinatra/asset_pipeline/task'
require_relative './config/environment'

# Type `rake -T` on your command line to see the available rake tasks.
task :console do
  Pry.start
end

namespace :db do
  desc "Clear database models"
  task :clear do
    if ENV["RACK_ENV"] == "development"
      ActiveRecord::Base.descendants.each do |model|
        model.delete_all
        puts "DB Clear: Completed .delete_all on #{model.name} model."
      end
    else
      puts "DB Clear: *** DO NOT RUN THIS IN PRODUCTION*** "
    end
  end

  desc "Update photos counter cache"
  task :photo_count do
    User.find_each {|user| User.reset_counters(user.id, :photos_count) }
    puts "DB Photo Count: User Photos Count Updated"
  end
end

namespace :default do
  desc "Change user to default queue"
  task :change do
    puts "Please provide a username to set as default queue..."
    username = STDIN.gets.chomp

    default = User.where(default: true).first
    user = User.find_by(username: username)

    if default && user
      if default.username == user.username
        puts "Error: #{username} is already set as default."
      else
        default.update(default: false)
        user.update(default: true)
        puts "Success: #{default.username} removed and #{user.username} set as default."
      end
    elsif user
      user.update(default: true)
      puts "Success: #{user.username} set as default, no previous user set."
    else
      puts "Error: username is not a valid user."
    end
  end
end

namespace :unsplash do
  desc "Generate Unsplash access token json file"
  task :token do
    if ENV["RACK_ENV"] == "development"
      begin
        puts "Please generate a new authorization code..."
        print "Authorization Code: "
        code = STDIN.gets.chomp

        Unsplash::Client.connection.authorize!(code)
        token = Unsplash::Client.connection.extract_token
        File.open("spec/token.json","w") do |f|
          f.write(token.to_json)
        end
      rescue Exception => e
        puts "Error: #{e.message}"
      end
      puts "Success: Unsplash token written to spec/token.json"
    else
      puts "Error: Must be in development environment."
    end
  end
end

Sinatra::AssetPipeline::Task.define! ApplicationController

