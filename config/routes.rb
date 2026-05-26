Rails.application.routes.draw do
  root "web/home#index"

  scope module: :web do
    post "auth/:provider", to: "auth#auth_request", as: :auth_request
    get "auth/:provider/callback", to: "auth#callback", as: :callback_auth, via: %i[get post]
    delete "logout", to: "auth#destroy", as: :logout
  end
end
