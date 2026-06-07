module Web
  class HomeController < ApplicationController
    def index
      @q = Bulletin.published.ransack(params[:q])
      @bulletins = @q.result(distinct: true)
        .with_attached_image
        .includes(:category, :user)
        .order(created_at: :desc)
        .page(params[:page]).per(12)
    end
  end
end
