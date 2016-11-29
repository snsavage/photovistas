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
  end
end

