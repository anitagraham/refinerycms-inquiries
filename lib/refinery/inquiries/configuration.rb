module Refinery
  module Inquiries
    include ActiveSupport::Configurable
    include ActiveSupport::NumberHelper

    config_accessor :show_contact_privacy_link
    config_accessor :show_company_field
    config_accessor :show_phone_number_field
    config_accessor :show_placeholders
    config_accessor :show_flash_notice
    config_accessor :send_notifications_for_inquiries_marked_as_spam
    config_accessor :from_name
    config_accessor :post_path, :page_path_new, :page_path_thank_you
    config_accessor :filter_spam, :recaptcha_site_key

    config_accessor :attachments_permitted
    config_accessor :attachments_permitted_types
    config_accessor :attachments_types_human
    config_accessor :attachments_types_js
    config_accessor :attachments_max_number
    config_accessor :attachments_max_size
    config_accessor :attachments_max_size_human
    config_accessor :attachments_external_uploader

    self.show_contact_privacy_link = true
    self.show_company_field = false
    self.show_phone_number_field = true
    self.show_placeholders = true
    self.show_flash_notice = false
    self.send_notifications_for_inquiries_marked_as_spam = false
    self.from_name = "no-reply"
    self.post_path = "/contact"
    self.page_path_new = "/contact"
    self.page_path_thank_you = "/contact/thank_you"
    self.filter_spam = true
    self.recaptcha_site_key = nil
    self.attachments_permitted = false
    self.attachments_max_size = 3.megabytes
    self.attachments_max_number = 3
    # array of mime types  %w[ image/png image/jpeg application/pdf]
    self.attachments_permitted_types = %w[image/jpeg image/png]
    self.attachments_external_uploader = false

    def self.attachments_max_size_human
      ActiveSupport::NumberHelper.number_to_human_size(self.attachments_max_size)
    end

    def self.attachments_types_js
      self.attachments_permitted_types.join(' ')
    end

    def self.attachments_types_human
      self.attachments_permitted_types.to_sentence(two_words_connector: ' or ', last_word_connector: ' or ')
    end

    def self.filter_spam
      config.filter_spam && config.recaptcha_site_key.blank?
    end
  end
end
