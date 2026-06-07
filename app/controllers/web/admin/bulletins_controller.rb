module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :set_bulletin, only: %i[show reject publish archive]
      def index
        @q = Bulletin.ransack(params[:q])
        @bulletins = @q.result(distinct: true)
                      .includes(:category, :user)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(10)
      end

      def show; end

      def moderation
        @q = Bulletin.under_moderation.ransack(params[:q])
        @bulletins = @q.result(distinct: true)
                      .includes(:category, :user)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(10)
      end

      def reject
        if @bulletin.may_reject?
          @bulletin.reject!
          redirect_to admin_bulletins_path, notice: t(".success")
        else
          redirect_to admin_bulletins_path, alert: t("bulletins.invalid_transition")
        end
      end

      def publish
        if @bulletin.may_publish?
          @bulletin.publish!
          redirect_to admin_bulletins_path, notice: t(".success")
        else
          redirect_to admin_bulletins_path, alert: t("bulletins.invalid_transition")
        end
      end

      def archive
        if @bulletin.may_archive?
          @bulletin.archive!
          redirect_to admin_bulletins_path, notice: t(".success")
        else
          redirect_to admin_bulletins_path, alert: t("bulletins.invalid_transition")
        end
      end

      private

      def set_bulletin
        @bulletin = Bulletin.with_attached_image.find(params[:id])
      end
    end
  end
end
