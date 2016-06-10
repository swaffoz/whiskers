require "whiskers/version"
require "fileutils"
require "thor"
require "pathname"

module Whiskers
  class Generator < Thor
    map ['v', '-v', '--version'] => :version
    map ['n', '-n', '--new'] => :new
    map ['w', '-w', '--watch'] => :watch

    desc 'version', 'Show Whiskers version'
    def version
      say "Whiskers #{Whiskers::VERSION}"
    end
    
    desc 'new NAME','Create new Whiskers site in NAME'
    option :template
    def new(name)
      install_base_files
      install_template options[:template] if options[:template]
      say "New Whiskers site created in #{name}"
    end
    
    desc 'watch', 'Watch a Whiskers directory and live compile coffeescript and SASS files'
    option :directory
    def version
## TODO
      if options[:directory]
        say "Watching for coffeescript and SASS changes in #{options[:directory]}"
      else
        say "Watching for coffeescript and SASS changes"
      end
    end

    private

    def install_base_files
## TODO
      make_install_directory
      install_bourbon
      install_neat
      install_bitters
      copy_in_scss_files
      copy_in_coffee_files
    end
    
    def install_template template
## TODO
    end
    
    def install_bourbon
## TODO
    end
        
    def install_neat
## TODO
    end
    
    def install_bitters
## TODO
    end

    def make_install_directory
## TODO
      FileUtils.mkdir_p(install_path)
    end

    def copy_in_scss_files
## TODO
      FileUtils.cp_r(all_stylesheets, install_path)
    end

    def all_stylesheets
## TODO
      Dir["#{stylesheets_directory}/*"]
    end

    def stylesheets_directory
## TODO
      File.join(top_level_directory, "core")
    end
    
    def copy_in_coffee_files
## TODO
      FileUtils.cp_r(all_stylesheets, install_path)
    end

    def all_scripts
## TODO
      Dir["#{scripts_directory}/*"]
    end

    def scripts_directory
## TODO
      File.join(top_level_directory, "core")
    end

    def top_level_directory
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
  end
end