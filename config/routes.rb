# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :auth do
    namespace :v1 do
      post :sign_in, to: 'auth#sign_in'
      post :sign_up, to: 'auth#sign_up'
      get :verify_email, to: 'auth#verify_email'
      get :verify_new_email, to: 'auth#verify_new_email'
    end
  end

  namespace :v1 do
    resources :accounts, except: %i[index create], shallow: true do
      resource :student, except: :destroy
    end
  end
end
