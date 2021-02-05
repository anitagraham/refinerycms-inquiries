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
    config_accessor :documents_permitted
    config_accessor :documents_permitted_types
    config_accessor :documents_max_number
    config_accessor :documents_max_size
    config_accessor :document_max_size_human

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
    self.documents_permitted = false
    self.documents_max_size = 3.megabytes
    self.documents_max_number = 3
    # array of mime types  %w[ image/png image/jpeg application/pdf]
    self.documents_permitted_types = %w[image/jpeg image/png]

    def self.document_max_size_human
      ActiveSupport::NumberHelper.number_to_human_size(self.documents_max_size)
    end

    def self.document_types_human
      self.documents_permitted_types.to_sentence(two_words_connector: ' or ', last_word_connector: ' or ')
    end

    def self.filter_spam
      config.filter_spam && config.recaptcha_site_key.blank?
    end
  end
end
