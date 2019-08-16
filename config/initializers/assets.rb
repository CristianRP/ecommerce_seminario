# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
# Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf)\z/
Rails.application.config.assets.precompile += %w[data_table_init.js base.scss base.js jquery/dist/jquery datatables/media/js/dataTables.bootstrap.min.js init.js bootstrap/dist/js/bootstrap]
