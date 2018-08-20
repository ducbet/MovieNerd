# Be sure to restart your server when you modify this file.

Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile +=
  %w(room_template.js room_template.css ticket.css)
