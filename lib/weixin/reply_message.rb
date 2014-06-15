module Weixin
    class ReplyMessage
        include ROXML
        xml_name :xml
        #xml_convention :camelcase

        xml_accessor :ToUserName, :cdata => true
        xml_accessor :FromUserName, :cdata => true
        xml_reader :CreateTime, :as => Integer
        xml_reader :MsgType, :cdata => true

        def initialize(to_user_name, from_user_name)
            @CreateTime = Time.now.to_i
            @ToUserName = to_user_name
            @FromUserName = from_user_name
        end

        def to_xml
           super.to_xml(:encoding => 'UTF-8', :indent => 0, :save_with => 0)
        end
    end

    class TextReplyMessage < ReplyMessage
        xml_accessor :Content, :cdata => true

        def initialize
            super
            @MsgType = 'text'
        end
    end

    class Music
        include ROXML

        xml_accessor :Title, :cdata => true
        xml_accessor :Description, :cdata => true
        xml_accessor :MusicUrl, :cdata => true
        xml_accessor :HQMusicUrl, :cdata => true
    end

    class MusicReplyMessage < ReplyMessage
        xml_accessor :Music, :as => Music

        def initialize(to_user_name, from_user_name)
            super
            @MsgType = 'music'
        end
    end

    class Item
        include ROXML

        xml_accessor :Title, :cdata => true
        xml_accessor :Description, :cdata => true
        xml_accessor :PicUrl, :cdata => true
        xml_accessor :Url, :cdata => true

    end

    class NewsReplyMessage < ReplyMessage
        xml_accessor :ArticleCount, :as => Integer
        xml_accessor :Articles, :as => [Item], :in => 'Articles', :from => 'item'

        def initialize(to_user_name, from_user_name)
            super
            @MsgType = 'news'
        end
    end
end