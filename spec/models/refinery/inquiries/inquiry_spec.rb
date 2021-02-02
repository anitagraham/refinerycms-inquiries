require 'spec_helper'

module Refinery
  module Inquiries
    describe Inquiry, :type => :model do
      describe "validations" do
        subject do
          FactoryBot.build(:inquiry, {
            name: "Ugis Ozols",
            email: "ugis.ozols@example.com",
            message: "Hey, I'm testing!"
          })
        end

        it { is_expected.to be_valid }

        describe '#errors' do
          subject { super().errors }
          it { is_expected.to be_empty }
        end

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq("Ugis Ozols") }
        end

        describe '#email' do
          subject { super().email }
          it { is_expected.to eq("ugis.ozols@example.com") }
        end

        describe '#message' do
          subject { super().message }
          it { is_expected.to eq("Hey, I'm testing!") }
        end

        it "validates name length" do
          expect(FactoryBot.build(:inquiry, {
            name: "a"*255,
            email: "ugis.ozols@example.com",
            message: "This Text Is OK"
          })).to be_valid
          expect(FactoryBot.build(:inquiry, {
            name: "a"*256,
            email: "ugis.ozols@example.com",
            message: "This Text Is OK"
          })).not_to be_valid
        end
        it "validates email length" do
          expect(FactoryBot.build(:inquiry, {
            name: "Ugis Ozols",
            email: "a"*243 + "@example.com",
            message: "This Text Is OK"
          })).to be_valid
          expect(FactoryBot.build(:inquiry, {
            name: "Ugis Ozols",
            email: "a"*244 + "@example.com",
            message: "This Text Is OK"
          })).not_to be_valid
        end
      end

      describe "default scope" do
        before { Refinery::Inquiries::Inquiry.destroy_all }
        it "orders by created_at in desc" do
          inquiry1 = FactoryBot.create(:inquiry, created_at: 1.hour.ago)
          inquiry2 = FactoryBot.create(:inquiry, created_at: 2.hours.ago)
          inquiries = Inquiry.all
          expect(inquiries.first).to eq(inquiry1)
          expect(inquiries.second).to eq(inquiry2)
        end
      end

      describe ".latest" do
        it "returns latest 7 non-spam inquiries by default" do
          8.times { FactoryBot.create(:inquiry) }
          Inquiry.last.toggle!(:spam)
          expect(Inquiry.latest.length).to eq(7)
        end

        it "returns latest 7 inquiries including spam ones" do
          7.times { FactoryBot.create(:inquiry) }
          Inquiry.all[0..2].each { |inquiry| inquiry.toggle!(:spam) }
          expect(Inquiry.latest(7, true).length).to eq(7)
        end

        it "returns latest n inquiries" do
          4.times { FactoryBot.create(:inquiry) }
          expect(Inquiry.latest(3).length).to eq(3)
        end
      end

      describe  'attachments' do
        let(:inquiry){FactoryBot.create(:inquiry, :with_attachments )}
        let(:too_many){FactoryBot.create(:inquiry, :with_attachments, uploads: [UploadHelper.jpg, UploadHelper.png])}
        let(:too_big){FactoryBot.create(:inquiry, :with_attachments, uploads: [UploadHelper.jpeg])}
        let(:wrong_type){FactoryBot.create(:inquiry, :with_attachments, uploads: [UploadHelper.pdf])}

        it 'has an attachment' do
          expect(inquiry.attachments.attached?).to be(true)
        end

        it 'is valid with attachments' do
          inquiry.valid?
          expect(inquiry).to be_valid
        end

        context 'when there are too many attachments' do
          it 'is invalid' do
            expect(too_many).to raise_error.with_message('No more than 1 attachments permitted')
            # expect(too_many.errors.messages[:attachments]).to eq ['No more than 1 attachments permitted']
          end
        end

        context 'when an attachment is too big' do
          it 'is invalid' do
            too_big.valid?
            expect(too_big.errors.messages[:attachments]).to eq("Attachments must be smaller than 100kb")
          end
        end

        context 'when an attachment has an invalid file type' do
          it 'is invalid' do
            wrong_type.valid?
            expect(wrong_type.errors).to eq('Attachments Attachments must be PNG, JPG, JPEG This attachment is application/pdf')
          end
        end

      end
    end
  end
end

