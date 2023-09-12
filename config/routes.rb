Rails.application.routes.draw do
  devise_for :users

  resources :user, only: %i[show edit update]

  resources :articles do
    resources :comments, only: %i[create destroy update edit]
  end

  get "/like_user/:id", to: "user#like"
  get "/like_article/:id", to: "articles#like"
  get "/like_comment/:article_id/:comment_id", to: "comments#like"
  root to: "articles#index"
end
