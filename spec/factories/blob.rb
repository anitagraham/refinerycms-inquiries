require "factory_bot"

FactoryBot.define do
  factory :blob, class: 'ActiveStorage::Blob' do
    name { "attachments" }
    record_type { Refinery::Inquiries::Inquiry }
  end
end
