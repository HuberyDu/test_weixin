# -*- encoding : utf-8 -*-
module Weixin
  # 微信内部路由规则类，用于简化配置
  class Router
    def initialize(options)
      @type = options[:type] if options[:type]
      @event = options[:event] if options[:event]
    end

    def matches?(request)
      xml = request.params[:xml]
      result = false
      puts "----------#{request.params}---------------"
      if xml && xml.is_a?(Hash)
        result = @type == xml[:MsgType] && @event == xml[:Event]
      end
      puts "------#{request.params[:xml][:type]}}------" if result
      return result
    end
  end    
end 