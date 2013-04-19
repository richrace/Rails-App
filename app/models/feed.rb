class Feed < ActiveRecord::Base

  has_and_belongs_to_many :broadcasts
  
  def as_json(options={})
    json = {:feed => self.name}
    return json
  end
end
