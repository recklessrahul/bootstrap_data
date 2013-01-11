BootstrapData::Application.routes.draw do

  resources :sources, :forms, :reports, :form_renderers, :applications, :roles

  root :to => 'pages#home'
  mount Resque::Server, :at => "/resque"

  resources :user_sessions, as: :user_sessions
  resources :users do
    member do
      get :activate
      put :confirm
    end
  end
    
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'view_reports/:id' => 'reports#view_report', :as => :view_reports
  match 'applications/invite_users/:id' => 'applications#invite', as: :invite_users
  match 'applications/:id/members' => 'applications#members', as: :application_members
  match 'select' => 'users#select_application', as: :select_application
end
