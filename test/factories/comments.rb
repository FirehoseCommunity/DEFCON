FactoryGirl.define do
  factory :comment do
    message 'TACOCAT and STACKCATS'
    association :user
    association :post 
  end
end


 