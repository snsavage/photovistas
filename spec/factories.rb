module FactoryGirl
  class DefinitionProxy
    def unsplash_data
      file = File.read('spec/token.json')
      data = JSON.parse(file)
    end
  end
end

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :username do |n|
    "jdoe#{n}"
  end

  factory :user do
    username
    email
    password "secret password"
    password_confirmation "secret password"

    factory :user_with_unsplash do
      unsplash_token unsplash_data
    end
  end
end

