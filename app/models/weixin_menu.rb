class WeixinMenu

  def self.init
    menu = Hash.new
    menu = {
        button: [
        {
          type:"click",
          name:"today_song",
          key:"V1001_TODAY_MUSIC"},
          {
            type:"click",
            name:"singer",
             key:"V1001_TODAY_SINGER"},
          {
             name:"menu",
             sub_button:[
             {  
                 type:"view",
                 name:"search",
                 url:"http://www.soso.com/"},
              {
                 type:"view",
                 name:"vider",
                 url:"http://v.qq.com/"},
              {
                 type:"click",
                 name:"cick_me",
                 key:"V1001_GOOD"}]}
              ]
             }
  end
end