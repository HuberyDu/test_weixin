# -*- encoding : utf-8 -*-
class WeixinController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality, except:[:init_menu]
  http_basic_authenticate_with name:"wx_test", password:"wx_test_secret", only: :init_menu

  def show
    render :text => params[:echostr]
  end

  def create
    render "text", :formats => :xml
  end

  def text_message
    @content = "我是回音：" + params[:xml][:Content]
    render "text", :formats => :xml
  end

  def default_message
    @content = params[:xml][:Content]
    render "text", :formats => :xml
  end

  def subscribe_message
    @content = "感谢您的关注"
    render "text", :formats => :xml
  end

  def image_message
    @image = "http://xiaolong.u.qiniudn.com/21.jpeg"
    render "image", :formats => :xml
  end

  def click_menu_message
    @content = params[:xml][:EventKey]
    render "text", :formats => :xml
  end

  def init_menu
    menu = WeixinMenu.init
    response = RestClient.post "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{@access_token}", 
                                              menu.to_json, :content_type => :json, :accept => :json
    errcode = (JSON.parse response)["errcode"]
    errcode == 0 ? @message = "success" : @message = errcode
  end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

end
