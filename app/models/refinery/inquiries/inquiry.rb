require 'refinery/core/base_model'
require 'filters_spam'

module Refinery
  module Inquiries
    class Inquiry < Refinery::Core::BaseModel
      include ActionView::Helpers::NumberHelper

      if Inquiries.filter_spam
        filters_spam message_field:    :message,
                     email_field:      :email,
                     author_field:     :name,
                     other_fields:     [:phone, :company],
                     extra_spam_words: %w()
      end

      validates :name, presence: true, length: { maximum: 255 }
      validates :email, format: {
        with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      }, length: { maximum: 255 }
      validates :message, presence: true

      default_scope { order('created_at DESC') }

      scope :ham, -> { where(spam: false) }
      scope :spam, -> { where(spam: true) }

      def self.latest(number = 7, include_spam = false)
        include_spam ? limit(number) : ham.limit(number)
      end

      has_many_attached :attachments, dependent: :purge_later

      validates :attachments,
                limit: { min: 0,
                         max: Refinery::Inquiries.attachments_max_number,
                         message: ::I18n.t('errors.messages.limit_out_of_range', max: Refinery::Inquiries.attachments_max_number)
                      },
                content_type: Refinery::Inquiries.attachments_permitted_types,
                size: { less_than_or_equal_to: Refinery::Inquiries.attachments_max_size,
                        message: ::I18n.t('errors.messages.size_out_of_range',
                                          max: Refinery::Inquiries.attachment_max_size_human)
                      }
    end
  end
end
