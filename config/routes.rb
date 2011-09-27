XSpace::Application.routes.draw do |map|
  map_restfully :search

  root :to => "searches#get"
end
