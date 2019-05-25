Rails.application.routes.draw do
  root to: 'users#index'
  resources :users do
    get 'download', on: :collection
    collection {post :import}
    get 'export', on: :collection
  end
end
