module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env["omniauth.auth"]

      email = auth.info.email.to_s.strip.downcase

      if email.blank?
        redirect_to root_path, alert: t(".email_required")
        return
      end

      user = User.find_or_initialize_by(email: email)
      user.name = auth.info[:name] if user.new_record? || auth.info[:name].present?

      if user.save
        session[:user_id] = user.id
        redirect_to root_path, notice: t(".success")
      else
        redirect_to root_path, alert: user.errors.full_messages.to_sentence
      end
    end

    def destroy
      reset_session
      redirect_to root_path, notice: t(".success")
    end
  end
end
