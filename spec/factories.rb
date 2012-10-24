FactoryGirl.define do
  factory :user do
    name      "Fulado de thal"
    email     "fulano@gmail.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end