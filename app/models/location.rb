class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :zipcode, type: String
  field :status, type: String , default: 'active'      
  

  has_many :keywords, :class_name => 'Location::Keyword'
  #has_many :images, :class_name => 'Store:key => "value", :Image'
  #has_one :state, :class => 'Location::State'
  has_and_belongs_to_many :state, :class_name => 'Location::State'

  def keywords
     Store::Branch.where(:store_id => self.id)
  end  

  def state
     Location::State.where(:location_id => self.id)
  end  
end
