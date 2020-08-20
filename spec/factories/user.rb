FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Settings.user.default_password }
    password_confirmation { Settings.user.default_password }
    role { Settings.admin }
  end
end
