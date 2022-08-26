module Refinery
  module Inquiries
    module InquiriesHelper
      include ActionView::Helpers::TranslationHelper

      def attachment_conditions_list
        tag.ul class: :tick do
          [attachments_count, attachments_size, attachments_types]
            .each.reduce(ActiveSupport::SafeBuffer.new) do |buffer, message|
            buffer << tag.li(message)
          end
        end
      end

      def attachments_count
        Refinery::Inquiries.attachments_max_number == 1 ? tws('.one_attachment') :
          tws('.many_attachments', quantity: Refinery::Inquiries.attachments_max_number)
      end

      def attachments_size
        tws('.attachments_max_size', quantity: Refinery::Inquiries.attachments_max_size_human)
      end

      def attachments_types
        tws('.attachments_types', types: Refinery::Inquiries.attachments_permitted_types.join(', '))
      end

      def inquiries_summary(view_path, count: 0, delete_path: nil, **options)
        link_text = "#{options[:label]} (#{count})"
        link_icon = [options[:icon_name], count.zero? ? 'empty' : nil, 'icon'].compact.join('_').to_sym
        delete_all = delete_button(options, delete_path, count)
        [link_to(link_text, view_path, class: link_icon), delete_all].compact.join(' ').html_safe
      end

      private

        def delete_button(options, path, count)
          return nil unless (options[:show_delete] && path && count > 0)

          label = "Delete all #{options[:label].pluralize}"
          link_to(label, path, method: :delete, remote: true, class: [:delete_icon, :button],
                  data: { confirm: 'Are you sure?' })
        end

        def translate_with_scope(key, options = {})
          default_scope = 'refinery.inquiries.conditions.html'
          ::I18n.translate(key, scope: default_scope, **options).html_safe
        end

        alias tws translate_with_scope
    end
  end
end
