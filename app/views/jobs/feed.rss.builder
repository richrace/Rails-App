xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.updated @updated
    xml.link jobs_url
  
    @jobs.each do |job|
      xml.item do     
        xml.title job.broadcast.title, :type => 'html'
        xml.description job.broadcast.content, :type => 'html'
        # the strftime is needed to work with Google Reader.
        xml.pubDate(job.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
        xml.author do
          xml.name job.broadcast.getAuthor
        end
        xml.link url_for(job)
      end
    end
  end
end