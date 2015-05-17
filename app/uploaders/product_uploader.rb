class ProductUploader < CarrierWave::Uploader::Base


  include CarrierWave::RMagick
  storage :file
  # 画像の上限を900x500にする
  process :resize_to_limit => [900, 500]

  

  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "img/store/products/pics/#{model.created_at.strftime('%Y-%m-%d')}/" + model.id.to_s[0, 2] + '/' + model.id.to_s
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :x150 do
    process resize_to_fill: [150, 150]
  end

  version :s480x320 do
    process resize_to_fill: [480, 320]
  end

  version :s230x130 do
    process resize_to_fill: [230, 130]
  end

  version :m300x320 do
    process resize_to_fill: [300, 320]
  end


  version :small do
    #process :resize_to_fit => [150, 150]
    process :resize_to_limit => [150, 150]
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    # "something.jpg" if original_filename
    "lefiores-store-products.jpg"  if original_filename

  end

end
