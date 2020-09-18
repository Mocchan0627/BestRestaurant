Rails.application.routes.draw do
  get 'restaurants/home'
  get 'restaurants/search'
  post 'restaurants/search'
  get 'restaurants/index'
  get 'restaurants/show/search' => 'restaurants#search'
  post 'restaurants/show/search' => 'restaurants#search'
  get 'restaurants/show/:id' => 'restaurants#show'
  post 'restaurants/favsave/:id' => 'restaurants#save'
  delete 'restaurants/favdelete/:id' => 'restaurants#delete'
end
