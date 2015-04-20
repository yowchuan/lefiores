class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :page

  mount_uploader :file, ImageUploader
  before_create :set_url

  field :site_id, type: Object
  field :file, type: String
  field :url, type: String
  field :page_id, type: Object
  index({ page_id: 1 }, {  name: "page_id_index"})
  field :user_id, type: Object
  field :ip, type: String

  def set_url
    url = self.file.url
  end


  #def to_jq_upload
  #  {
  #      "name" => read_attribute(:file),
  #      "size" => file.size,
  #      "url" => file.url,
  #      "thumb_url" => file.thumb.url,
  #      #"delete_url" => gallery_picture_path(:id => id),
  #      "delete_type" => "DELETE"
  #  }
  #end



end
