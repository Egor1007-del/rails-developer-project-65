module Web
  class AuthController < ApplicationController
    def auth_request
    end

    def callback
      auth = request.env["omniauth.auth"]

      email = auth.info.email
      name = auth.info.name || auth.info.nickname

      user = User.find_or_initialize_by(email: email)
      user.name = name

      if user.save
        session[:user_id] = user.id
        redirect_to root_path, notice: t(".success")
      else
        redirect_to root_path, alert: user.errors.full_messages.to_sentence
      end
    end

    def destroy
      reset_session
      redirect_to root_path, notice: t(".logged_out")
    end
  end
end
