module Refinery
  module Inquiries
    module Admin
      class InquiriesController < ::Refinery::AdminController
        include Rails.application.routes.url_helpers

        crudify :'refinery/inquiries/inquiry',
                :title_attribute => "name",
                :order => "created_at DESC"

        helper_method :group_by_date

        before_action :find_all_ham, :only => [:index]
        before_action :find_all_spam, :only => [:spam]
        before_action :get_spam_count, :only => [:index, :spam]

        def index
          @inquiries = @inquiries.with_query(params[:search]) if searching?
          @inquiries = @inquiries.with_attached_attachments
          @inquiries = @inquiries.page(params[:page])
        end

        def spam
          self.index
          render :action => 'index'
        end

        def toggle_spam
          find_inquiry
          @inquiry.toggle!(:spam)

          redirect_back fallback_location: root_path
        end

        protected

        def find_all_ham
          @inquiries = Refinery::Inquiries::Inquiry.ham
        end

        def find_all_spam
          @inquiries = Refinery::Inquiries::Inquiry.spam
        end

        def get_spam_count
          @spam_count = Refinery::Inquiries::Inquiry.where(:spam => true).count
        end

        private

        def inquiry_params
          params.require(:inquiry).permit(:name, :phone, :message, :email)
        end

      end
    end
  end
end
