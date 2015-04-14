class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  #field :name, type: String
  field :zipcode, type: String
  field :delivery_fee, type: String
  field :keywords, type: String
  field :name, type: String
  field :city, type:Object
  field :state, type:Object
  

  field :state_id, type: Object
  field :city_id, type: Object
  # def state
  #    Location::State.where(:id=>self.state_id).first
  # end
  
  field :status, type: String , default: 'active'      
  

  #has_many :keywords, :class_name => 'Location::Keyword'
  #has_many :images, :class_name => 'Store:key => "value", :Image'
  #has_one :state, :class => 'Location::State'
  #has_many :location_state, :class_name => 'Location::State'

  has_one :location_city
  has_one :location_state

  after_find :set_city_and_state
  def set_city_and_state
    self.city = Location::City.where(:id => self.city_id.to_s).first    
    self.state = Location::State.where(:id => self.state_id.to_s).first    
  end
  
end
