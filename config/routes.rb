NameToFaceCrawler::Application.routes.draw do
  resources :faces, :only => :show, :id => /[^\/]+/
end
