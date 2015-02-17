class Store
  include Mongoid::Document
  include Mongoid::Timestamps
  field :img_url, type: String
  field :business_reg_no, type: String
  field :contact_no, type: String
  field :page_url, type: String
  field :user_id, type: Object
  field :user_email, type: String

  has_many :branch, :class_name => 'Store::Branch'
  has_many :images, :class_name => 'Store::Image'
  belongs_to :user

end
