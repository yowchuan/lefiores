class Location::State
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :Location, :class_name => 'Location'  

     
  #field :views, :type => Integer, :default => 0
  field :name, :type => String
  field :location_id, :type => String
  field :status, type: String , default: 'active'  

  
  belongs_to :location, :class_name => 'Location'
end
