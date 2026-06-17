module Web
  class ApplicationController < ::ApplicationController
    include Pundit::Authorization
    include AuthManagement

    rescue_from Pundit::NotAuthorizedError do
      redirect_to root_path, alert: t("pundit.not_authorized")
    end
  end
end
