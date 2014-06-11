# -*- encoding : utf-8 -*-
TestWeixin::Application.routes.draw do
  resource :weixin do
    member do
      get :add_menu
      get :init_menu
    end
  end

  scope :path => "/weixin", :via => :post do 
    root :to => 'weixin#text_message', :constraints => lambda { |request| request.params[:xml][:MsgType] == 'text' }
    root :to => 'weixin#image_message', :constraints => lambda { |request| request.params[:xml][:MsgType] == 'image' }
    root :to => 'weixin#subscribe_message', :constraints => lambda { |request| request.params[:xml][:MsgType] == "event" and request.params[:xml][:Event] == "subscribe" }
    root :to => 'weixin#click_menu_message', :constraints => lambda { |request| request.params[:xml][:MsgType] == "event" and request.params[:xml][:Event] == "CLICK" }
  end
end
