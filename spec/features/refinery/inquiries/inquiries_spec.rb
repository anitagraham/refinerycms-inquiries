require "spec_helper"

module Refinery
  module Inquiries

    describe "Inquiries", type: :feature do

      def making_an_inquiry(name, email, message)

        ensure_on(refinery.inquiries_new_inquiry_path)

        fill_in "Name", with: name
        fill_in "Email", with: email
        fill_in "Message", with: message
        click_button "Send Message"
      end

      before do
        # load in seeds we use in migration
        Refinery::Inquiries::Engine.load_seed
      end

      it "posts to the correct URL" do
        visit refinery.inquiries_new_inquiry_path
        expect(page).to have_selector("form[action='#{refinery.inquiries_inquiries_path}']")
      end

      context "when given valid data" do
        it "is successful" do
          visit refinery.inquiries_new_inquiry_path
          expect { making_an_inquiry('Ugis Ozols', 'ugis.ozols@refinerycms.com', "Hey, I'm testing!") }.to change(Refinery::Inquiries::Inquiry, :count).by(1)
          expect(page.current_path).to eq(refinery.thank_you_inquiries_inquiries_path)
          expect(page).to have_content("Thank You")

          within "#body_content" do
            expect(page).to have_content("We've received your inquiry and will get back to you with a response shortly.")
            expect(page).to have_content("Return to the home page")
            expect(page).to have_selector("a[href='/']")
          end
        end
      end

      context "when given invalid data" do

        it "does not save the inquiry" do
          visit refinery.inquiries_new_inquiry_path
          expect { making_an_inquiry('my name 😀 ', 'jun!k@ok', '☄︎☀︎☽ ') }.not_to change(Refinery::Inquiries::Inquiry, :count)
          expect(page).to have_content("Email is invalid")
        end

      end
      describe 'configuration' do
        describe "privacy" do
          context "when 'show contact privacy link' setting is false" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_contact_privacy_link).and_return(false)
            end

            it "won't show link" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_no_content("We value your privacy")
              expect(page).to have_no_selector("a[href='/privacy-policy']")
            end
          end

          context "when' show contact privacy link' setting is true" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_contact_privacy_link).and_return(true)
            end

            it "shows the link" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_content("We value your privacy")
              expect(page).to have_selector("a[href='/privacy-policy']")
            end
          end
        end

        describe "placeholders" do
          context "when show placeholders setting set to false" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_placeholders).and_return(false)
            end

            it "won't show placeholders" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_no_selector("input[placeholder]")
            end
          end

          context "when show placeholders setting set to true" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_placeholders).and_return(true)
            end

            it "shows the placeholders" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_selector("input[placeholder]")
            end
          end
        end

        describe "phone number" do
          context "when 'show phone numbers' setting is false" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_phone_number_field).and_return(false)
            end

            it "won't have an input field for phone number" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_no_selector("label", text: 'Phone')
              expect(page).to have_no_selector("#inquiry_phone")
            end
          end

          context "when 'show phone numbers' setting is true" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_phone_number_field).and_return(true)
            end

            it "there is an input field for phone number" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_selector("label", text: 'Phone')
              expect(page).to have_selector("#inquiry_phone")
            end
          end
        end

        describe "company" do
          context "when 'show company' setting is false" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_company_field).and_return(false)
            end

            it "won't show company" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_no_selector("label", text: 'Company')
              expect(page).to have_no_selector("#inquiry_company")
            end
          end

          context "when 'show company' setting is true" do
            before(:each) do
              allow(Refinery::Inquiries.config).to receive(:show_company_field).and_return(true)
            end

            it "shows the company" do
              visit refinery.inquiries_new_inquiry_path

              expect(page).to have_selector("label", text: 'Company')
              expect(page).to have_selector("#inquiry_company")
            end
          end
        end
      end

      describe 'Attachments:' do

        let(:file_png) { file_fixture('fathead.png') }
        let(:file_jpg) { file_fixture('beach.jpeg') }
        let(:file_jpg2) { file_fixture('beach-alternate.jpeg') }

        def inquiry_with_attachments(attachments)
          ensure_on(refinery.inquiries_new_inquiry_path)

          fill_in "Name", with: 'Ugis Ozols'
          fill_in "Email", with: 'ugis.ozols@refinerycms.com'
          fill_in "Message", with: 'Sending you an attachment'
          attach_file(attachments, multiple: true, name: 'inquiry[attachments][]')
          click_button "Send Message"
        end

        context 'when not permitted' do
          before do
            allow(Refinery::Inquiries.config).to receive(:attachments_permitted).and_return(false)
          end

          it 'provides no means to insert attachments' do
            visit refinery.inquiries_new_inquiry_path
            expect(page).to have_no_content('Uploading Documents')
            expect(page).to have_no_selector('.attachments')
          end
        end

        context 'when attachments are permitted' do
          before do
            allow(Refinery::Inquiries.config).to receive(:attachments_permitted).and_return(true)
          end

          it 'provides attachment section in the new inquiry form' do
            visit refinery.inquiries_new_inquiry_path
            expect(page).to have_content('Uploading Documents')
            expect(page).to have_selector('.attachments')
          end

          describe 'limited file types' do
            before do
              allow(Refinery::Inquiries.config).to receive(:attachments_permitted_types).and_return(['image/png'])
            end

            it 'uploads a file with a permitted type' do
              expect {
                inquiry_with_attachments(file_png)
              }.to change(ActiveStorage::Attachment, :count).by(1)

              expect(Refinery::Inquiries::Inquiry.first.attachments.count).to eq(1)
            end

            it "doesn't upload file with a type that is not permitted" do
              expect {
                inquiry_with_attachments(file_jpg)
              }.not_to change(ActiveStorage::Attachment, :count)
            end
          end
          describe 'limit on number of files' do
            before do
              allow(Refinery::Inquiries.config).to receive(:attachments_permitted_types).and_return(['image/png', 'image/jpeg'])
              allow(Refinery::Inquiries.config).to receive(:attachments_max_number).and_return(1)
              allow(Refinery::Inquiries.config).to receive(:attachments_max_size).and_return(1.megabyte)
            end

            it 'uploads files if there are fewer (or equal) than the maximum' do
              expect { inquiry_with_attachments(file_png) }.to change(ActiveStorage::Attachment, :count).by(1)
            end

            it 'does not upload files if there are more than the maximum' do
              expect { inquiry_with_attachments([file_png, file_jpg2]) }.not_to change(ActiveStorage::Attachment, :count)
            end
          end

          describe 'limit on size of files' do
            before do
              allow(Refinery::Inquiries.config).to receive(:attachments_permitted_types)
                                                     .and_return(['image/png', 'image/jpeg'])
              allow(Refinery::Inquiries.config).to receive(:attachments_max_size).and_return(100.kilobytes)
            end
            it 'uploads a file if it is under the size limit' do
              assert(file_png.size < 100.kilobytes)
              expect { inquiry_with_attachments(file_png) }.to change(ActiveStorage::Attachment, :count).by(1)
            end

            it 'does not upload a file if it is over the size limit' do
              assert(file_jpg.size > 100.kilobytes)
              expect { inquiry_with_attachments(file_jpg) }.not_to change(ActiveStorage::Attachment, :count)
            end
          end
          describe 'when a fancy js uploader is wanted' do
            before do
              allow(Refinery::Inquiries.config).to receive(:attachments_external_uploader).and_return(true)
            end
            it 'places a trigger button on the page' do
              visit refinery.inquiries_new_inquiry_path
              expect(page).to have_button('upload_trigger')
            end
            it 'places information about attachments in the form' do
              visit refinery.inquiries_new_inquiry_path
              expect(page).to have_selector('div[data-direct-upload-url]')
              expect(page).to have_selector('div[data-field-name]')
            end

          end
        end
      end
    end
  end
end
