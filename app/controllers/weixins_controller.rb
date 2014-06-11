# -*- encoding : utf-8 -*-
class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # before_filter :check_weixin_legality

  def show
    render :text => params[:echostr]
  end

  def create
    if params[:xml][:MsgType] == "text"
      @content = "我是回音：" + params[:xml][:Content]
    elsif params[:xml][:MsgType] == "event" and params[:xml][:Event] == "subscribe"
      @content = "感谢您的关注"
    end
    render "echo", :formats => :xml
  end

  def create_menu
    main_menu = Array.new
    init_data
    get_access_token
    do_post(@menu, @access_token)
    render json: @menu.to_json
    binding.pry
  end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def get_access_token
    uri = URI.parse 'https://api.weixin.qq.com/cgi-bin/token?'
    uri.query = URI.encode_www_form(grant_type: "client_credential", appid: "wxcbd762df133385fb", secret: "f0b21749f556463703f285a045cc9588")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    body = JSON.parse response.body
    @access_token = body["access_token"]
  end

  def do_post(data, token)
    url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{token}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = data.to_json
    response = http.request(request)
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




