module Web
  class HomeController < ApplicationController
    def index
      @q = Bulletin.published.ransack(params[:q])
      @bulletins = @q.result(distinct: true).includes(:category, :user).order(created_at: :desc)
    end
  end
end
