Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch("GITHUB_CLIENT_ID", ""), ENV.fetch("GITHUB_CLIENT_SECRET", ""), scope: "user"
end

if Rails.env.test?
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider: "github",
    uid: "",
    info: { email: "", name: "" },
    extra: { admin: false }
  )

  OmniAuth.config.before_callback_phase do |env|
    params = env["omniauth.params"] || {}
    mock_auth = OmniAuth.config.mock_auth[:github]

    email = params["email"] || mock_auth.info.email || "user@test.com"
    name = params["name"] || mock_auth.info.name || email.split("@").first

    env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: "github",
      uid: email,
      info: {
        email: email,
        name: name
      },
      extra: {
        admin: params["admin"] == "true"
      }
    )
  end
end
