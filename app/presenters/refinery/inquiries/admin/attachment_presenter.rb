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

        def self.collection(documents, context)
          documents.map { |att| new(att, context) }
        end

        def to_html
          [paperclip, attachment.filename.base, *actions].join(' ').html_safe
        end

        private

          def paperclip
            "📎"
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
              [info, download].join(' ').html_safe
            end
          end

          def download
            action_icon(:download, context.rails_blob_path(attachment, disposition: "attachment"), t('.download'))
          end

      end
    end
  end
end
