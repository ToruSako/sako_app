require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SakoApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

config.generators.test_framework      = :rspec
config.generators.system_tests        = false
config.generators.stylesheets         = false
config.generators.javascripts         = false
config.generators.helper              = false
#config.generators.helper_specs        = false
config.generators.view_specs          = false
config.generators do |g|

  # Railsジェネレータがfactory_bot用のファイルを生成するのを無効化
  g.factory_bot false

  # ファクトリファイルの置き場を変更
  g.factory_bot dir: 'custom/dir/for/factories'
end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
