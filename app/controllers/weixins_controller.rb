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
    params.each do |name, value|
      i ||= 1
      temp_menu = Array.new
      if name == "main_menu_" + "#{i.to_s}"
        temp_menu = ({type: "view", name: value, url:"www.baidu.com"})
      end
      main_menu.push(temp_menu)
    end
    @menu = Hash.new
    @menu["buttons"] = main_menu
    getToken
    doPost
  end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def getToken
    uri = URI.parse 'https://api.weixin.qq.com/cgi-bin/token?'
    uri.query = URI.encode_www_form(grant_type: "client_credential", appid: "wxcbd762df133385fb", secret: "f0b21749f556463703f285a045cc9588")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    body = JSON.parse response.body
    @access_token = body["access_token"]
  end

  def doPost
    url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{@token}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = @menu.to_json
    response = http.request(request)
    binding.pry
  end


end