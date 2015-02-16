class Store::Branch
  include Mongoid::Document
  
  belongs_to :store
  
  #field :views, :type => Integer, :default => 0
  field :contact_no, :type => String, :default => ''
  field :postal_code, :type => String
  #this field is store name + branch name ex: petalika_main or petalika_solaris
  field :sub_name, :type => String
  field :business_hours, type: String
  field :cut_off_time, type: String
  
  #has_and_belongs_to_many :fav_users, :class_name => 'User'
  #has_and_belongs_to_many :recent_topic_pages, :class_name => 'Topic::Page'
  #has_many :recent_topic_pages, :class_name => 'Topic::Page'
  #has_and_belongs_to_many :hot_topic_pages, :class_name => 'Topic::Page'
  
end
