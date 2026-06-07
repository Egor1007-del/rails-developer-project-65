module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, except: %i[ show ]

    def show
      @bulletin = Bulletin.with_attached_image.find(params[:id])

      return if @bulletin.published?
      return if signed_in? && @bulletin.user == current_user
      return if signed_in? && current_user.admin?

      redirect_to root_path, alert: t("auth.required")
    end

    def new
      @bulletin = Bulletin.new
    end

    def create
      @bulletin = current_user.bulletins.build(bulletin_params)

      if @bulletin.save
        redirect_to profile_path, notice: t(".success")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @bulletin = current_user.bulletins.find(params[:id])

      redirect_to profile_path, alert: t(".not_editable") unless @bulletin.draft? || @bulletin.rejected?
    end

    def update
      @bulletin = current_user.bulletins.find(params[:id])

      unless @bulletin.draft? || @bulletin.rejected?
        redirect_to profile_path, alert: t(".not_editable")
        return
      end

      if @bulletin.update(bulletin_params)
        redirect_to profile_path, notice: t(".success")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def to_moderate
      @bulletin = current_user.bulletins.find(params[:id])

      if @bulletin.may_to_moderate?
        @bulletin.to_moderate!
        redirect_to profile_path, notice: t(".success")
      else
        redirect_to profile_path, alert: t("bulletins.invalid_transition")
      end
    end

    def archive
      @bulletin = current_user.bulletins.find(params[:id])

      if @bulletin.may_archive?
        @bulletin.archive!
        redirect_to profile_path, notice: t(".success")
      else
        redirect_to profile_path, alert: t("bulletins.invalid_transition")
      end
    end

    private

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
