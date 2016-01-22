FactoryGirl.define do
  factory :user do
    sequence :email do |n|
     "awesometestuser#{n}@example.com"
    end
    name "Mega Tron"
    password "password"
    password_confirmation "password"
  end 
end
