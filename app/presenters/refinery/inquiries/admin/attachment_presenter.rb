# frozen_string_literal: true

require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module Refinery
  module Inquiries
    module Admin
      class AttachmentPresenter
        include ActionView::Helpers::TagHelper
        include ActionView::Helpers::UrlHelper
        include Refinery::TagHelper

        attr_accessor :attachment, :created_at, :context, :urls, :collection
        delegate :refinery, :output_buffer, :output_buffer=, :t, to: :context
        delegate_missing_to :attachment

        def initialize(attachment, context)
          @context = context
          @attachment = attachment
        end

        def self.collection(attachments, context)
          attachments.map { |att| new(att, context) }
        end

        def to_html
          [paperclip, name_and_preview, *actions].join(' ').html_safe
        end

        private

          def paperclip
            "📎"
          end
          def name_and_preview
            attachment.filename.base
            # , href: variant(resize_to_limit: [100, 100]), class: :image
          end

          def preview_image
            return unless variable?
            variant(resize_to_limit: [100, 100])
          end
          def info
            action_icon :info, '', attachment_information
          end

          def attachment_information
            [attachment.content_type, context.number_to_human_size(attachment.byte_size), dimensions].join(' ').html_safe
          end

          def dimensions
            [attachment.metadata[:width], attachment.metadata[:height]].join('x')
          end

          def actions
            tag.span class: :actions do
              [ info, download].join(' ').html_safe
            end
          end

          def download
            Rails.logger.debug "Attachment URL: #{context.rails_blob_url(attachment)}"
            action_icon(:download, context.rails_blob_url(attachment, disposition: "attachment"), 'Download')
          end

      end
    end
  end
end
