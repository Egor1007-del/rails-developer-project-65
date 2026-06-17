Rails.application.routes.draw do
  scope module: :web do
    root "bulletins#index"

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
      root "bulletins#moderation"

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
