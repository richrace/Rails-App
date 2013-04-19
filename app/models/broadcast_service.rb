
class BroadcastService
  
  # The content in the broadcast object will be broadcast to each feed in
  # the feeds hash. Any communication failures will be flagged with an
  # error message in the value of the corresponding feed in the feeds hash
  # and false will be returned, otherwise true is returned
  # Really this should be more OO and the case statement replaced by
  # polymorphic calls. This is left to the reader as an exercise, but ideally
  # you would want to make this a singleton rather than use class scope methods. The
  # error handling mechanism is also a bit clunky and non-user friendly.
  def self.broadcast(broadcast, feeds)
    result = {:result => [], :feeds => []}
        
    if feeds != nil
      feeds.each do |feed, value|
        case feed
        when "twitter"
          result[:result].concat(via_twitter(broadcast))
          result[:feeds] << ['Twitter']
        when "email"
          result[:result].concat(via_email(broadcast))
          result[:feeds] << ['E-mail']
        when "blog"
          result[:feeds] << ['Blog', 'RSS', 'Atom']
          if broadcast.feed_type == Broadcast::JOB_S 
            add_job(broadcast)
          elsif broadcast.feed_type == Broadcast::NEWSBLOG_S
            add_news(broadcast)
          end
        when "facebook"
          result[:feeds] << ['Facebook']
          add_feed(broadcast, 'facebook')
          # TO DO. Not yet implmented.
        end
      end
    end
    result
  end

  private
  
  def self.add_job(broadcast)
    @job = Job.new(broadcast.id)
    broadcast.job = @job
    if broadcast.save 
      add_feed(broadcast, 'atom')
      add_feed(broadcast, 'RSS')
      add_feed(broadcast, 'blog')
    end
  end
  
  def self.add_news(broadcast)
    @newsblog = Newsblog.new(broadcast.id)
    broadcast.newsblog = @newsblog
    if broadcast.save 
      add_feed(broadcast, 'atom')
      add_feed(broadcast, 'RSS')
      add_feed(broadcast, 'blog')
    end
  end 
  
  def self.via_email(broadcast)
    # Iterate across all users sending an email to each.
    begin
      users = User.find(:all)    
      users.each do |user|
        if broadcast.feed_type == Broadcast::NEWSBLOG_S 
          NewsBroadcast.send_news(user, broadcast, email_list).deliver
        elsif broadcast.feed_type == Broadcast::JOB_S && user.jobs 
          NewsBroadcast.send_news(user, broadcast, email_list).deliver
        end
      end
      add_feed broadcast, 'email'
      return []
    rescue => e
      return [:feed => email_list, :code => 500, :message => e.message]
    end
  end

  def self.via_twitter(broadcast)
    if broadcast.title.blank?
      broadcast.title = "Twitter Post"
      broadcast.save
    end
    if broadcast.feed_type == Broadcast::JOB_S
      add_to_job_twitter(broadcast)
    elsif broadcast.feed_type == Broadcast::NEWSBLOG_S
      add_to_newsblog_twitter(broadcast)
    end
  end
  
  def self.add_to_job_twitter(broadcast)
    send_twitter(broadcast)
  end
    
  def self.add_to_newsblog_twitter(broadcast)
    send_twitter(broadcast)
  end
    
  def self.send_twitter(broadcast)
    result = []
    begin
      # SINCE AUG 2010 TWITTER REQUIRES OAUTH, SO BASIC AUTH NO LONGER SUPPORTED.
      # Now using two-legged OAuth authentication (see initializers/twitter.rb) to
      # obtain an access token object
      response = TWITTER_ACCESS_TOKEN.post('/statuses/update.json', { :status => broadcast.content })
   
      case response
      when Net::HTTPSuccess
        # Now wire up with the correct feed
        add_feed broadcast, 'twitter'
      else # Something went wrong
        result = [:feed => 'twitter', :code => response.code, :message => response.message]
      end
    rescue => e
      result = [:feed => 'twitter', :code => 500, :message => e.message]
    end
    result
  end

  def self.add_feed(broadcast, feed_name)
    feed = Feed.find_by_name(feed_name)
    broadcast.feeds << feed if feed
  end
end
