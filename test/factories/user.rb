FactoryGirl.define do
  factory :user do
    sequence :email do |n|
     "robertsapunarich#{n}@gmail.com"
    end
    password "password"
    password_confirmation "password"
  end 
end
