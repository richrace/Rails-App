atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated
  feed.link newsblogs_url
  
  @newsblogs.each do |item|
    next if item.updated_at.blank?

    feed.entry(item) do |entry|
            
      entry.title item.broadcast.title, :type => 'html'
      entry.content item.broadcast.content, :type => 'html'
      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.author do
        entry.name item.broadcast.getAuthor
      end
    end
  end
end