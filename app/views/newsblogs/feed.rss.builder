xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.updated @updated
    xml.link newsblogs_url
  
    @newsblogs.each do |newsblog|
      xml.item do     
        xml.title newsblog.broadcast.title, :type => 'html'
        xml.description newsblog.broadcast.content, :type => 'html'
        # the strftime is needed to work with Google Reader.
        xml.pubDate(newsblog.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
        xml.author do
          xml.name newsblog.broadcast.getAuthor
        end
        xml.link url_for(newsblog)
      end
    end
  end
end