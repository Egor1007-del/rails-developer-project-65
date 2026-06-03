Rails.application.routes.draw do
  scope module: :web do
    root "home#index"

    post "auth/:provider", to: "auth#auth_request", as: :auth_request
    match "auth/:provider/callback", to: "auth#callback", as: :callback_auth, via: %i[get post]
    delete "logout", to: "auth#destroy", as: :logout


    resources :bulletins, only: %i[new create show edit update] do
      member do
        patch :to_moderate
        patch :archive
      end
    end

    resource :profile, only: %i[show]

    namespace :admin  do
      resources :categories

      resources :bulletins, only: %i[index show] do
        member do
          patch :publish
          patch :reject
          patch :archive
        end

        collection do
          get :moderation
        end
      end
    end
  end
end
