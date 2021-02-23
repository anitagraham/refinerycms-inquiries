module Refinery
  module Inquiries
    module InquiriesHelper
      include ActionView::Helpers::TranslationHelper

      def attachment_conditions_list
        tag.ul class: :tick do
          [attachments_count, attachment_size, attachment_types]
            .each.reduce(ActiveSupport::SafeBuffer.new) do |buffer, message|
            buffer << tag.li(message)
          end
        end
      end

      def attachments_count
        Refinery::Inquiries.attachments_max_number == 1 ? tws('.one_attachment') :
          tws('.many_attachments', quantity: Refinery::Inquiries.attachments_max_number)
      end

      def attachment_size
        tws('.attachment_max_size', quantity: Refinery::Inquiries.attachment_max_size_human)
      end

      def attachment_types
        tws('.attachment_types', types: Refinery::Inquiries.attachments_permitted_types.join(', '))
      end

      private

        def translate_with_scope(key, options = {})
          default_scope = 'refinery.inquiries.conditions.html'
          ::I18n.translate(key, scope: default_scope, **options).html_safe
        end

        alias tws translate_with_scope
    end
  end
end

