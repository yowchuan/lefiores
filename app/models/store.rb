class User::Store
  include Mongoid::Document
  field :img_url, type: String
  field :business_reg_no, type: String
  field :contact_no, type: String
  field :pageUrl, type: String
  
  has_many :branch, :class_name => 'Store::Branch'
  has_many :images, :class_name => 'Store::Image'
  belongs_to :user
end
