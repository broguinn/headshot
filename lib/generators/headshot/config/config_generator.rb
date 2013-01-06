require 'rails'

module Headshot
  module Generators
    class ConfigGenerator < ::Rails::Generators::Base
      desc "This generator configures the application so it would be able to communicate with the Headshot Flash binary."
      source_root File.expand_path('../../../../../lib/assets', __FILE__)

      def copy_flash_middleware
        say_status('copying', 'Copying Flash session cookie middleware ...')
        begin
          say_status('creating', 'Creating directory app/middlewares.')
          Dir.mkdir('app/middlewares')
        rescue Errno::EEXIST => e
          say('Directory app/middlewares exists!')
        end

        copy_file('../middlewares/flash_session_cookie_middleware.rb', 'app/middlewares/flash_session_cookie_middleware.rb')
      end

      def load_middlewares_in_application_rb
        application_rb_path = "config/application.rb"
        code_marker = "class Application < Rails::Application"
        loading_code = 'config.autoload_paths += %W(#{config.root}/app/middlewares)'
        say_status('checking', 'Checking if application.rb contains the loading code for the middleware.')

        inject_into_file application_rb_path, :after => "#{code_marker}\n" do
          "\t\t#{loading_code}\n"
        end
      end
    end
  end
end