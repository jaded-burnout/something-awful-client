require "models/post"

FactoryBot.define do
  factory :post do
    skip_create

    sequence(:id) { |n| n.to_s }
    sequence(:author) { |n| "Forums User #{n}" }
    text { "This is a post" }
    timestamp { Time.now }
  end
end
