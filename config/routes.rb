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
      resource :student, except: :destroy, shallow: true do
        resources :examinations, shallow: true do
          resources :examination_items
        end
      end
      resource :tutor, except: :destroy, shallow: true do
        resources :academic_histories
        resources :work_histories
      end
    end

    resources :subjects, only: :index
  end
end
