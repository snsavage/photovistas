ENV["RACK_ENV"] ||= "development"

require 'sinatra/activerecord/rake'
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
end


