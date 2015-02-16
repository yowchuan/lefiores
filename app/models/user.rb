class User
  include Mongoid::Document	
  include Mongoid::Timestamps
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  field :role, type: Symbol, default: 'florist'

  validates :email, uniqueness: true

  has_one :store, :class_name  => 'User::Store'
  #field :crypted_password, type: String, default: ""
end
