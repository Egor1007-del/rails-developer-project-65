ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user)
    sign_in_with_github(email: user.email, name: user.name)
    follow_redirect!
  end

  def sign_in_with_github(email:, name: nil)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: "github",
      uid: email.to_s,
      info: {
        email: email,
        name: name || email.to_s.split("@").first
      },
      extra: { admin: false }
    )

    post callback_auth_path(provider: "github")
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end
end
