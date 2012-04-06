FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password  "firebird"
    password_confirmation "firebird"
    
    factory :admin do
      admin true
    end
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
