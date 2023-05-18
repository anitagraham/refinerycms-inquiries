module Refinery
  module Inquiries
    module InquiriesHelper

      def inquiries_summary(view_path, count: 0, delete_path: nil, **options)
        link_text = "#{options[:label]} (#{count})"
        link_icon = [options[:icon_name], count.zero? ? 'empty' : nil, 'icon'].compact.join('_').to_sym
        delete_all = delete_button(options, delete_path, count)
        [link_to(link_text, view_path, class: link_icon), delete_all].compact.join(' ').html_safe
      end

      def delete_button(options, path, count)
        return nil unless (options[:show_delete] && path && count > 0)

        label = "Delete all #{options[:label].pluralize}"
        link_to(label, path, method: :delete, remote: true, class: [:delete_icon, :button],
                data: { confirm: 'Are you sure?' })
      end

      def attachment_conditions
        tag.ul do
          [attachments_count, attachments_size, attachment_types].reduce(ActiveSupport::SafeBuffer.new) do |buffer, condition|
            buffer << tag.li(condition)
          end
        end
      end

      def attachments_count
        Inquiries::Attachments.max_count == 1 ?
          translate_with_scope('.one_attachment') :
          translate_with_scope('.many_attachments', quantity: Inquiries::Attachments.max_count)
      end

      def attachments_size
        translate_with_scope('.max_size', quantity: number_to_human_size(Inquiries::Attachments.max_size))
      end

      def attachment_types
        simple_types = Inquiries::Attachments.permitted_types.map{|item|  item.split('/').last}.uniq
        translate_with_scope('.types', types: simple_types.to_sentence(two_words_connector: ' or ', last_word_connector: ' or '))
      end

      def translate_with_scope(key, options = {})
        default_scope = 'refinery.inquiries.inquiries.attachments'
        ::I18n.translate(key, scope: default_scope, **options).html_safe
      end

    end
  end
end
