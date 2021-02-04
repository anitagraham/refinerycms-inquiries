require "factory_bot"

FactoryBot.define do
  factory :inquiry, class: "Refinery::Inquiries::Inquiry" do
    name { "Refinery" }
    email { "refinery@example.com" }
    message { "Hello..." }

    trait :with_documents do
      transient do
        uploads { [UploadHelper.jpeg] }
      end

      after :build do |inquiry, evaluator|
        evaluator.uploads.each { |upload|
          inquiry.documents.attach(upload)
        }
      end
    end
  end
end
