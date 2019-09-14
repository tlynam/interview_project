Rails.application.routes.draw do
  get 'populations', to: 'populations#index'
  get 'populations/by_year', to: 'populations#show'

  get 'the_logz', to: 'logs#index'
end
