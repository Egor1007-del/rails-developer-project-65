module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, except: %i[index show]

    def index
      @q = Bulletin.published.ransack(params[:q])
      @bulletins = @q.result(distinct: true)
        .with_attached_image
        .includes(:category, :user)
        .order(created_at: :desc)
        .page(params[:page]).per(12)
    end

    def show
      @bulletin = Bulletin.with_attached_image.find(params[:id])
      authorize @bulletin
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
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
    end

    def update
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin

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
