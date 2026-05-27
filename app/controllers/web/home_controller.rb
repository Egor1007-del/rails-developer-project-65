module Web
  class HomeController < ApplicationController
    def index
      @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
    end
  end
end
