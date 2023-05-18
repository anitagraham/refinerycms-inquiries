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

    config_accessor :active_storage_prefix
    config_accessor :active_storage_service

    config_accessor :attachments_permitted

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

    self.active_storage_service = nil
    self.active_storage_prefix = nil

    self.attachments_permitted = true


    def self.filter_spam
      config.filter_spam && config.recaptcha_site_key.blank?
    end
  end
end
