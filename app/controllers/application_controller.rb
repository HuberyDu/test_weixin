# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_access_token

  def get_access_token
      params = {grant_type: "client_credential", appid: Rails.configuration.weixin_appid, secret: Rails.configuration.weixin_secret}
      response = RestClient.get 'https://api.weixin.qq.com/cgi-bin/token', {params: params}
      errcode = (JSON.parse response)["errcode"]
      @access_token = (JSON.parse response)["access_token"]
      Rails.cache.write("access_token", @access_token, expires_in: 5.minutes)
      @access_token = Rails.cache.read("access_token")
  end

end
