class Location::City
  include Mongoid::Document
  include Mongoid::Timestamps
  
  #field :views, :type => Integer, :default => 0
  field :name, :type => String  
  field :status, type: String , default: 'active'  
    
  belongs_to :location
end 
