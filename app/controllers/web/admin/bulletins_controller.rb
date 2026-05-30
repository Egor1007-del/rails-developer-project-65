module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :set_bulletin, only: %i[show reject publish archive]
      def index
        @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
      end

      def show; end

      def moderation
        @bulletins = Bulletin.under_moderation.includes(:category, :user).order(created_at: :desc)
      end

      def reject
        @bulletin.reject!

        redirect_to admin_bulletins_path, notice: t(".success")
      end

      def publish
        @bulletin.publish!

        redirect_to admin_bulletins_path, notice: t(".success")
      end

      def archive
        @bulletin.archive!

        redirect_to admin_bulletins_path, notice: t(".success")
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
