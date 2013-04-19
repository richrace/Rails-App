class Broadcast < ActiveRecord::Base

  # The only restriction is that broadcasts must have some data to
  # be valid and an associated broadcaster (user_id)
  validates_presence_of :content

  belongs_to :user
  has_and_belongs_to_many :feeds
  has_one :job, :dependent => :destroy
  has_one :newsblog, :dependent => :destroy

  JOB_S = "Job"
  NEWSBLOG_S = "News"
  
  def to_s
    result = "id: " + id.to_s + " title: " + title + " content: " + content
    if user
       result += " user: " + user.id.to_s
    end
    result
  end

  def self.per_page
    8
  end
  
  def has_job?
    if self.job != nil
      return true
    else 
      return false
    end
  end
  
  def has_newsblog?
    if self.newsblog != nil
      return true
    else 
      return false
    end
  end
  
  def getAuthor
    name = self.user.firstname
    name += " "
    name += self.user.surname
    return name
  end
  
  def as_json(options={})
    json = {:broadcast => {
      :id => self.id, 
      :type => self.feed_type, 
      :title => self.title, 
      :author => {
        :name => self.getAuthor, 
        :id => self.user.id
      }, 
      :content => self.content, 
      :created_at => self.created_at, 
      :updated_at => self.updated_at, 
      :feeds => self.feeds
      }
    }
    return json
  end

  
  def to_xml(options={})
    options[:indent]||=2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])    
    xml.instruct! unless options[:skip_instruct]
    xml.broadcast do
      xml.id self.id, :type => 'integer'
      xml.type self.feed_type
      xml.title self.title, :type => 'html'
      xml.author do
        xml.name self.getAuthor
        xml.id self.user.id, :type => 'integer'
      end
      xml.content self.content, :type => 'html'
      xml.created_at self.created_at, :type => 'datetime'
      xml.updated_at self.updated_at, :type => 'datetime'
      xml.feeds do
        self.feeds.each do |feed|
          xml.feed feed.name
        end
      end
    end
  end
  
end
