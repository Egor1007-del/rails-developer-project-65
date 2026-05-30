Rails.application.routes.draw do
  scope module: :web do
    root "home#index"

    post "auth/:provider", to: "auth#auth_request", as: :auth_request
    match "auth/:provider/callback", to: "auth#callback", as: :callback_auth, via: %i[get post]
    delete "logout", to: "auth#destroy", as: :logout


    resources :bulletins, only: %i[new create] do
      member do
        patch :to_moderate
        patch :archive
      end
    end

    resource :profile, only: %i[show]

    namespace :admin  do
      root "bulletins#index", as: :root
      resources :bulletins, only: %i[index]
      resources :categories
    end
  end
end
