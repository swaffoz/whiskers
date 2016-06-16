require 'whiskers/version'
require 'bourbon'
require 'bitters'
require 'neat'
require 'fileutils'
require 'thor'
require 'pathname'
require 'open-uri'

module Whiskers
  class Generator < Thor

    map ['v', '-v', '--version'] => :version
    map ['n', '-n', '--new'] => :new
    map ['w', '-w', '--watch'] => :watch

    desc 'version', 'Show Whiskers version'
    def version
      puts "Whiskers #{Whiskers::VERSION}"
    end
    
    desc 'new NAME','Create new Whiskers site named NAME'
    method_options :template => :string
    def new(name)
      if name.nil? || name.empty?
        puts 'No name specified for new site. Failed to install Whiskers.'
        return
      end
      
      template = options[:template].nil? ? 'base' : options[:template]
      
      if !templates.include? template
        puts "Template #{template} does not exist. Failed to install Whiskers."
        return
      end
      
      install_template_in_directory(template, name)
      puts "New Whiskers site created in #{name}"
    end
    
    desc 'watch', 'Watch a Whiskers directory and live compile coffeescript and SASS files'
    method_options :path => :string
    def watch
      puts "Watching for coffeescript and SASS changes #{options[:path]}"
      puts 'Press enter to stop.'
      
      coffee_thread = Thread.new do
        system("cd #{options[:path]} && " +
               "coffee --watch --output scripts/lib --compile scripts/src")
      end
      
      sass_thread = Thread.new do
        system("cd #{options[:path]} && " + 
               "sass --watch stylesheets/app.sass:stylesheets/app.css")
      end

      gets
      coffee_thread.kill
      sass_thread.kill
    end

    private
    
    def templates
      @templates = ['base', 'blog', 'store']
    end

    def install_template_in_directory(template, directory)
      make_install_directory directory
      
      install_stylesheets_for_template_in_directory(template, directory)
      install_scripts_for_template_in_directory(template, directory)
      
      install_bourbon_in_directory directory
      install_neat_in_directory directory
      install_bitters_in_directory directory
      
      install_jquery_in_directory directory
      install_normalize_in_directory directory
    end
    
    def make_install_directory directory
      FileUtils.mkdir_p(directory)
    end
    
    def install_stylesheets_for_template_in_directory(template, directory)
      FileUtils.cp_r(all_stylesheets_for_template(template), directory)
    end

    def install_scripts_for_template_in_directory(template, directory)
       install_path = File.join(directory, 'scripts')
       FileUtils.cp_r(all_scripts_for_template(template), directory)
    end

    def install_bourbon_in_directory directory
      install_path = File.join(directory, 'stylesheets', 'plugins')
      g = Bourbon::Generator.new([],{path: install_path})
      g.install
    end
        
    def install_neat_in_directory directory
      install_path = File.join(directory, 'stylesheets', 'plugins')
      ## Neat's install method doesn't allow you to set the path :(  
      #g = Neat::Generator.new([],{path: install_path})
      #g.install
      system("cd #{install_path} && neat install")
    end
    
    def install_bitters_in_directory directory
      install_path = File.join(directory, 'stylesheets', 'plugins')
      g = Bitters::Generator.new([],{path: install_path})
      g.install
    end
    
    def install_normalize_in_directory directory
      install_path = File.join(directory,
                               'stylesheets', 
                               'plugins', 
                               'normalize.scss')
      normalize_url = 'https://github.com/necolas/normalize.css/blob/master/normalize.css'
      File.open(install_path, 'wb') do |f|
        f.write open(normalize_url).read 
      end
    end
    
    def install_jquery_in_directory directory
      install_path = File.join(directory, 
                               'scripts', 
                               'lib', 
                               'plugins', 
                               'jquery.min.js')
      jquery_url = 'https://code.jquery.com/jquery-3.0.0.min.js'
      File.open(install_path, 'wb') do |f|
        f.write open(jquery_url).read 
      end
    end

    def all_stylesheets_for_template template
      Dir["#{stylesheets_directory_for_template template}/*"]
    end

    def stylesheets_directory_for_template template
      File.join(top_level_directory, 'core', 'whiskers', template, 'stylesheets')
    end

    def all_scripts_for_template template
      Dir["#{scripts_directory_for_template template}/*"]
    end

    def scripts_directory_for_template template
      File.join(top_level_directory, 'core', 'whiskers', template, 'scripts')
    end

    def top_level_directory
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
  end
end