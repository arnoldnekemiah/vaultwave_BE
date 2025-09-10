Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show] do
        member do
          get :waitlist_position
        end
      end
      resources :referrals, only: [:create, :show]
      get "referral/:code", to: "referrals#validate_code"
    end
  end

end
