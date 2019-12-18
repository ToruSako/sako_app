FactoryBot.define do
  factory :memos, class: Micropost do
    trait :memo_1 do
      memo { "I just ate an orange!" }
      picture { nil }
      user_id { 1 }
      created_at { 10.minutes.ago }
    end

    trait :memo_2 do
      memo { "Check out the @tauday site by @mhartl: http://tauday.com" }
      picture { nil }
      user_id { 1 }
      created_at { 3.years.ago }
    end

    trait :memo_3 do
      memo { "Sad cats are sad: http://youtu.be/PKffm2uI4dk" }
      picture { nil }
      user_id { 1 }
      created_at { 2.hours.ago }
    end

    trait :memo_4 do
      memo { "Writing a short test" }
      picture { nil }
      user_id { 1 }
      created_at { Time.zone.now }
    end
    association :user, factory: :user
  end
end
