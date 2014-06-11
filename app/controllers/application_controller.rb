# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_access_token

  def get_access_token
    Rails.cache.fetch("access_token") do
      params = {grant_type: "client_credential", appid: Rails.configuration.weixin_appid, secret: Rails.configuration.weixin_appid}
      response = RestClient.get 'https://api.weixin.qq.com/cgi-bin/token', {params: params}
      access_token = (JSON.parse response)["access_token"]
      Rails.cache.write('access_token', access_token, :expires_in => 7200.seconds)
    end
  end
end
