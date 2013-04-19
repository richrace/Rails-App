require 'active_support/builder' unless defined?(Builder)

class Job < ActiveRecord::Base

  validates_presence_of :broadcast_id
  
  belongs_to :broadcast
  
  def as_json(options={})
    json = {
      :job => {
        :id => self.id, 
        :title => self.broadcast.title, 
        :author => {
          :name => self.broadcast.getAuthor
        }, 
        :content => self.broadcast.content, 
        :created_at => self.created_at, 
        :updated_at => self.updated_at, 
        :feeds => self.broadcast.feeds
      }
    }
    return json
  end
  
  def to_xml(options={})
    options[:indent]||=2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])    
    xml.instruct! unless options[:skip_instruct]
    xml.job do
      xml.id self.id, :type => 'integer'
      xml.broadcast_id self.broadcast.id, :type => 'integer'
      xml.title self.broadcast.title, :type => 'html'
      xml.author do
        xml.name self.broadcast.getAuthor
      end
      xml.content self.broadcast.content, :type => 'html'
      xml.created_at self.created_at, :type => 'datetime'
      xml.updated_at self.updated_at, :type => 'datetime'
      xml.feeds do
        self.broadcast.feeds.each do |feed|
          xml.feed feed.name
        end
      end
    end
  end
end

