FactoryGirl.define do
  factory :post do
    title "all of the things"
    body "you must do them"
    association :user
  end
end
