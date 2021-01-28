module Refinery
  module Inquiries
    module InquiriesHelper

      def add_attachments(max, max_size, types)
        #  going to ignore the validations for the moment
        tag.section id: :attachments do
          [header, notes(max, max_size, types), upload(max)].join(' ').html_safe
        end
      end

      def header; end

      def notes(_max, _max_size, _types)
        ;
      end

      def upload(max)
        logger.debug "Writing #{max} upload fields"
        tag.div class: :uploads do
          tag.div class: :upload do
            label = tag.label(:attachments, class: :label)
            field = tag.input(id: "upload", multiple: true, class: :input, type: :file, name: "inquiry[upload][]", direct_upload: 'true')
            [label, field].join(' ').html_safe
          end
        end
      end

    end
  end
end
