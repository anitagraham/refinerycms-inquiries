require "spec_helper"

module Refinery
  module Inquiries
    describe 'attachments', type: feature do
      describe 'configuration and validation' do
        describe 'attachments_permitted' do
          context 'when attachments are not permitted' do
            allow(Refinery::Inquiries)
            it 'provides no means to insert attachments' do

            end
          end
          context 'when attachments are permitted' do

            it 'inserts an attachment field into the new inquiry form' do

            end

          end
          describe 'attachments_permitted_types' do

          end

          describe 'attachments_max_number' do

          end
          describe 'attachments_max_size' do

          end
        end
      end

      describe 'uploading attachments' do

      end
    end
  end
end
