# -*- encoding : utf-8 -*-
TestWeixin::Application.routes.draw do
  # resource :weixin, only:[:show] do
  #    collection do
  #      get "init_menu"
  #    end
  # 
  get 'weixin' => "weixin#show"
  get 'weixin/init_menu' => "weixin#init_menu"
 
  scope :path => "/weixin", :via => :post do 
    root :to => 'weixin#text_message', :constraints => Weixin::Router.new(:type => "text")
    root :to => 'weixin#image_message', :constraints => Weixin::Router.new(:type => "image")
    root :to => 'weixin#subscribe_message', :constraints => Weixin::Router.new(:type => "event", :event => "CLICK")
    root :to => 'weixin#click_menu_message', :constraints => Weixin::Router.new(:type => "event", :event => "subscribe")
  end
end