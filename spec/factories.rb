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
      unsplash_username "scott_qf"
    end
  end

  sequence :unsplash_id do |n|
    "unsplash_id_#{n}"
  end

  factory :photo do
    unsplash_id
    thumb_url "https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=853362bc9b185da3d049a4754c39163d"
    full_url "https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=853362bc9b185da3d049a4754c39163d"
  end
end

