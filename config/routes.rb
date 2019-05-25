Rails.application.routes.draw do
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'

  root to: 'users#index'
  resources :users do
    get 'download', on: :collection
    collection {post :import}
    get 'export', on: :collection
  end
  resources :posts
end
