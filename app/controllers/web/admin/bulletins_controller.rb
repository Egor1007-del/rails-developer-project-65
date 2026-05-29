module Web
  module Admin
    class BulletinsController < ::ApplicationController
      def index
        @bulletins = Bulletin.includes(:categories, :user).order(created_at: :desc)
      end
    end
  end
end
