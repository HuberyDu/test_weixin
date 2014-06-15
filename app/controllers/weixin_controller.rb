# -*- encoding : utf-8 -*-
require "#{Rails.root}/lib/weixin/reply_message" 

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
    content = params[:xml][:Content]
    case content
    when "音乐"
      render xml: music_reply_message
    when "新闻"
      render xml: news_reply_message
    end
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

  def music_reply_message
    message = Weixin::MusicReplyMessage.new(params[:xml][:FromUserName], params[:xml][:ToUserName])
    music = Weixin::Music.new
    music.Title = "梦一场"
    music.Description = "那英"
    music.MusicUrl = "http://xiaolong.u.qiniudn.com/%E6%A2%A6%E4%B8%80%E5%9C%BA.mp3"
    message.Music = music
  end

  def news_reply_message
    message = Weixin::NewsReplyMessage.new(params[:xml][:FromUserName], params[:xml][:ToUserName])
    item = Weixin::Item.new
    item.Title = "鲁尼助攻扳平球巴神绝杀"
    item.Url = "http://2014.sina.com.cn/news/eng/2014-06-15/06475557.shtml"
    item.Description = "北京时间6月15日6时(巴西时间14日19时)，世界杯D组首轮第2场在马瑙斯亚马逊球场展开较量，意大利2比1力擒英格兰[微博]，与哥斯达黎加同积3分"
    item.PicUrl = "http://www.sinaimg.cn/dy/slidenews/69_img/2014_24/56732_47695_607814.jpg"
    message.ArticleCount = 1
    message.Articles = [item]
    message.to_xml
  end
end
