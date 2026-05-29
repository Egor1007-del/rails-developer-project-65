module Web
  module Admin
    class ApplicationController < Web::ApplicationController
      before_action :authorize_admin!

      private
      def authorize_admin!
        authorize :admin, :access?
      end
    end
  end
end
