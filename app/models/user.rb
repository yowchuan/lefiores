class User
  include Mongoid::Document	
  include Mongoid::Timestamps
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true

  #field :crypted_password, type: String, default: ""
end
