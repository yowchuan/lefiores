class Store::Product::Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :product, :class_name => 'Store::Product' 
   

  field :name, type: String
  field :description, type: String
  validates_presence_of :name, :message => 'This field is required'
  index({ name: 1 }, {  name: "product_category_title"})
  
end
