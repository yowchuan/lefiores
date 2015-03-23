class Location::State
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :Location, :class_name => 'Location' 
   
  
  #field :views, :type => Integer, :default => 0
  field :name, :type => String
  field :location_id, :type => String
  
  #has_and_belongs_to_many :fav_users, :class_name => 'User'
  #has_and_belongs_to_many :recent_topic_pages, :class_name => 'Topic::Page'
  #has_many :recent_topic_pages, :class_name => 'Topic::Page'
  #has_and_belongs_to_many :hot_topic_pages, :class_name => 'Topic::Page'
  
end
