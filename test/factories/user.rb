FactoryGirl.define do
  factory :user do
    sequence :email do |n|
     "robertsapunarich#{n}@gmail.com"
    end
    name "Robert Sapunarich"
    password "password"
    password_confirmation "password"
  end 
end
