class Test
  include Mongoid::Document
  include Mongoid::Timestamps

  field :att1, type: String
  field :att2, type: String
end
