class User
  include Mongoid::Document	
  include Mongoid::Timestamps
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  field :role, type: Symbol, default: 'florist'
  field :has_store, type: Boolean , default: false  


  validates :email, uniqueness: true

  has_one :store

  #field :crypted_password, type: String, default: ""
end
