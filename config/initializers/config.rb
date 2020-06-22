Config.setup do |config|
  config.const_name = "Settings"
end

CarrierWave.configure do |config|
 config.cache_storage = :file
end