# -*- encoding : utf-8 -*-
module Weixin
  # 微信内部路由规则类，用于简化配置
  class Router
    def initialize(options)
      @message_type = options[:type] if options[:message_type]
      @event = options[:event] if options[:event]
      @event_key = options[:event_key] if options[:event_key]
      @content = options[:content] if options[:content]
    end

    def matches?(request)
      xml = request.params[:xml]
      if xml && xml.is_a?(Hash)
        (return false unless @message_type == xml[:MsgType]) if @message_type
        (return false unless @event == xml[:Event]) if @event
        (return false unless @event_key == xml[:EventKey]) if @event_key && @event_key.is_a?(String)
        (return false unless @event_key =~ xml[:EventKey]) if @event_key && @event_key.is_a?(Regexp)
        (return false unless @content == xml[:Content]) if @content && @content.is_a?(String)
        (return false unless @content =~ xml[:Content]) if @content && @content.is_a?(Regexp)
      end
      return true
    end
  end    
end 