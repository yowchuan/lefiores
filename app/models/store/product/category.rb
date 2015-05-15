class Store::Product::Category
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :product, :class_name => 'Product' 
  has_many :Product 

  field :title, type: String
  field :description, type: String
  validates_presence_of :title, :message => 'This field is required'
  index({ title: 1 }, {  name: "product_category_title"})
  
end
