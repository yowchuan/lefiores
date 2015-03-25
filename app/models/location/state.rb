class Location::State
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :Location, :class_name => 'Location' 
  has_many :state_cities, :class_name => 'Location::City'

     
  #field :views, :type => Integer, :default => 0
  field :name, :type => String
  field :location_id, :type => String
  field :status, type: String , default: 'active'  
  
  before_save :set_state_cities
  def set_state_cities
    self.state_cities.each do |city|
      if city.state_ids.include?(self.id)
        city.game_ids.delete(self.id) 
        city.save
      end
    end            
  end  
end
