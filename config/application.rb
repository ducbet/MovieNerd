require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module MovieNerd
  class Application < Rails::Application
    config.load_defaults 5.2
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :vi]
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.assets.initialize_on_precompile = false
  end
end
