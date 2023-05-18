module Refinery
  module Inquiries
    module Attachments
      include ActiveSupport::Configurable

      config_accessor :external_uploader
      config_accessor :max_count
      config_accessor :max_size
      config_accessor :permitted_types

      self.max_size = 3.megabytes
      self.max_count = 3
      self.permitted_types = %w[image/jpeg image/png]
      self.external_uploader = false

      end
  end
end
