class User
  include Mongoid::Document	
  include Mongoid::Timestamps
  authenticates_with_sorcery!

  #validates :password, length: { minimum: 6 }
  

  field :role, type: Symbol, default: 'florist'
  field :has_store, type: Boolean , default: false  


  validates :email, uniqueness: true
  validates :email, presence: true
  validates :password, confirmation: true
  #validates :password_confirmation, presence: true
  #validates :password, presence: true
  #validates :password_confirmation, presence: true
  #validates_length_of :password, :minimum => 5, :allow_blank => true, :message => :please_provide_five_or_more_characters

  has_one :store
  field :branch_id, type: Object

  

  #field :crypted_password, type: String, default: ""
end
