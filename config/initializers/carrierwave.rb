CarrierWave.configure do |config|
  config.storage = :grid_fs
  config.root = Rails.root.join('public')
  config.cache_dir = "uploads"

  config.grid_fs_access_url = '/uploads/'
end