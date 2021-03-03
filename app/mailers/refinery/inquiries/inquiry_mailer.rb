module Refinery
  module Inquiries
    class InquiryMailer < ActionMailer::Base
      include Rails.application.routes.url_helpers

      def confirmation(inquiry, request)
        @inquiry, @request = inquiry, request
        mail :subject   => Refinery::Inquiries::Setting.confirmation_subject(Mobility.locale),
             :to        => inquiry.email,
             :from      => from_info,
             :reply_to  => Refinery::Inquiries::Setting.notification_recipients.split(',').first
      end

      def notification(inquiry, request)
        @inquiry, @request = inquiry, request
        mail :subject   => Refinery::Inquiries::Setting.notification_subject,
             :to        => Refinery::Inquiries::Setting.notification_recipients,
             :from      => from_info,
             :reply_to  => inquiry.email
      end

      private

      def from_info
        "\"#{from_name}\" <#{from_mail}>"
      end

      def from_name
        ::I18n.t('from_name',
                :scope => 'refinery.inquiries.config',
                :site_name => Refinery::Core.site_name,
                :name => @inquiry.name)
      end

      def from_mail
        Rails.logger.debug @request.domain.presence
        from_domain = @request.domain || 'caststone.com.au'
        "#{Refinery::Inquiries.from_name}@#{from_domain}"
      end

      def attached_files(attached)
        attached.each do |att|
          attachments[att.blob.filename] = att.download
        end
      end
    end
  end
end
