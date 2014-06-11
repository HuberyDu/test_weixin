# -*- encoding : utf-8 -*-
class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality, only: :show

  def show
    render :text => params[:echostr]
  end

  def create
    if params[:xml][:MsgType] == "text"
    elsif 
    end
    render "echo", :formats => :xml
  end

  def text_message
    @content = "我是回音：" + params[:xml][:Content]
    render "text", :formats => :xml
  end

  def subscribe_message
    @content = "感谢您的关注"
    render "text", :formats => :xml
  end

  def image_message
    render "image", :formats => :xml
  end

  def click_menu_message
    @content = params[:xml][:EventKey]
    render "text"
  end

  def init_menu
    WeixinMenu.init menu
    init_data
    access_token = get_access_token
    response = RestClient.post "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{access_token}", 
                                              @menu.to_json, :content_type => :json, :accept => :json
    render json: @menu.to_json
  end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def get_access_token
    if Rails.cache.read("access_token").nil? 
      params = {grant_type: "client_credential", appid: "wxcbd762df133385fb", secret: "f0b21749f556463703f285a045cc9588"}
      response = RestClient.get 'https://api.weixin.qq.com/cgi-bin/token', {params: params}
      access_token = (JSON.parse response)["access_token"]
      Rails.cache.write('access_token', access_token, :expires_in => 7200.seconds)
    else
      Rails.cache.read("access_token")
    end
  end

  def init_data
    @menu = Hash.new
    main_menu = Array.new
    main_menu_1 = ({type: "view", name: "menu_1", url:"www.baidu.com"})
    main_menu_2 = ({type: "click", name: "menu_2", key: "menu_2"})
    sub_menu = Array.new
    sub_menu[0] = ({type: "view", name: "sub_menu_3_1", url:"www.baidu.com"})
    sub_menu[1] = ({type: "click", name: "sub_menu_3_2", key:"sub_menu_3_2"})
    sub_menu[2] = ({type: "click", name: "sub_menu_3_3", key:"sub_menu_3_3"})
    main_menu_3 = Hash.new
    main_menu_3= {sub_button: sub_menu, name: "caidan"}
    main_menu.push(main_menu_1)
    main_menu.push(main_menu_2)
    main_menu.push(main_menu_3)
    @menu["button"] = main_menu
  end
end




