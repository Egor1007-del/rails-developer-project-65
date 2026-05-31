module Web
  class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def show
      @q = current_user.bulletins.ransack(params[:q])
      @bulletins = @q.result(distinct: true)
        .includes(:category)
        .order(created_at: :desc)
        .page(params[:page])
        .per(10)
    end
  end
end
