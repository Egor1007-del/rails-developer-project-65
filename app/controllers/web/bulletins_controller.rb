module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, except: %i[ show ]

    def show
      @bulletin = Bulletin.published.find(params[:id])
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

    def to_moderate
      @bulletin = current_user.bulletins.find(params[:id])

      @bulletin.to_moderate!
      redirect_to profile_path, notice: t(".success")
    end

    def archive
      @bulletin = current_user.bulletins.find(params[:id])

      @bulletin.archive!
      redirect_to profile_path, notice: t(".success")
    end

    private

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
