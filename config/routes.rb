Rails.application.routes.draw do

  resources :laura_filters
  resources :england_news
  resources :scotlands do
    get :compare, on: :collection
  end
  resources :northern_irelands
  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all


  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  root to: "scotlands#index"
  get "ngofilter", to: 'laura_filters#index'
  get "scotsprofile", to: 'scotlands#profile'
  get "scotsfilter", to: 'scotlands#index'
  get 'scotscompare', to: 'scotlands#comparison'
  get 'scotscompare_all', to: 'scotlands#compare_all'
  get "northern_irelandprofile", to: 'northern_irelands#profile'
  get "northern_irelandfilter", to: 'northern_irelands#index'
  get "northern_irelandcompare", to: 'northern_irelands#comparison'
  get "northern_irelandcompare_all", to: 'northern_irelands#compare_all'
  get "engprofile2", to: 'england_news#profile'
  get "engfilter", to: 'england_news#index'
  get "engcompare", to: 'england_news#comparison'
  get 'engcompare_all', to: 'england_news#compare_all'
  get "scotland_cookie", to: 'scotlands#add_to_cookie'
  get "scotland_cookie_remove", to: 'scotlands#remove_from_cookie'
  get "scotland_cookie_delete", to: 'scotlands#delete_cookie'
  get "ireland_cookie", to: 'northern_irelands#add_to_cookie'
  get "ireland_cookie_remove", to: 'northern_irelands#remove_from_cookie'
  get "ireland_cookie_delete", to: 'northern_irelands#delete_cookie'
  get "england_cookie", to: 'england_news#add_to_cookie'
  get "england_cookie_remove", to: 'england_news#remove_from_cookie'
  get "england_cookie_delete", to: 'england_news#delete_cookie'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
