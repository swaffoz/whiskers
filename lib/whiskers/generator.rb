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
    map ['l', '-l', '--list', '--list-templates'] => :list

    desc 'version', 'Show Whiskers version'
    def version
      puts "Whiskers #{Whiskers::VERSION}"
    end
    
    desc 'new SITE','Create new Whiskers site named SITE'
    long_desc <<-LONGDESC
      `whiskers new SITE` will create a new Whiskers site named site. You must specify a 
      name for the site. All Whiskers files will be placed in a directory of the name 
      provided. 
 
      You can optionally specify a second parameter, which will set the template for the 
      new Whiskers site.
 
      > $ whiskers new SITE blog
      
      If no template is specified, the base template will be used.
      You can see a list of templates available by using `whiskers --list-templates`
    LONGDESC
    def new(name, template=nil)
      if name.nil? || name.empty?
        puts 'No name specified for new site. Failed to install Whiskers.'
        return
      end
      
      selected_template = template.nil? ? 'base' : template
      
      if !templates.include? selected_template
        puts "Template #{template} does not exist. Failed to install Whiskers."
        puts "Try `whiskers --list-templates` to see the templates that are available."
        return
      end
      
      install_template_in_directory(selected_template, name)
      puts "New Whiskers site created in #{name}"
      puts "\nRun `whiskers watch` from inside #{name}/ to get started"
    end
    
    desc 'watch', 'Watch a Whiskers directory and compile CoffeeScript and SASS files'
    long_desc <<-LONGDESC
      `whiskers watch` will listen and compile changes made to the CoffeeScript files
      (located in scripts/src) and SASS files (located in stylesheets).
      
      You must be in the directory for the site you want to watch for changes.
      
      It is equivalant to running the following two commands:
        - `coffee --watch --output scripts/lib --compile scripts/src`
        - `sass --watch stylesheets/app.sass:stylesheets/app.css`
      
      Compilation can be stopped by pressing the enter key.
    LONGDESC
    def watch
      puts "Watching for CoffeeScript and SASS changes. Press enter to stop.\n\n"
      
      coffee_pid = spawn("coffee --watch --output scripts/lib --compile scripts/src")
      sass_pid = spawn("sass --watch stylesheets/app.sass:stylesheets/app.css")
      
      enter_key = $stdin.gets.chomp

      Process.kill("KILL", coffee_pid)      
      Process.kill("KILL", sass_pid)
      Process.wait
      
      puts "\nCompilation Stopped."
    end
    
    desc 'list', 'List the templates available to Whiskers.'
    def list
      puts "Templates available to Whiskers:"
      templates.map { |t| puts "\t- #{t}" }
      puts "\nCreate a new site with `whiskers new SITE TEMPLATE`\n"
    end

    private
    
    def templates
      @templates = Dir.entries(templates_directory).select { |f| !File.directory? f }.collect { |p| p.to_s } # ['base', 'blog', 'store']
    end

    def install_template_in_directory(template, directory)
      make_install_directory directory
      
      install_stylesheets_for_template_in_directory(template, directory)
      install_scripts_for_template_in_directory(template, directory)
      install_markup_for_template_in_directory(template, directory)
      
      install_bourbon_in_directory directory
      install_neat_in_directory directory
      install_bitters_in_directory directory
      
      install_jquery_in_directory directory
      install_require_in_directory directory
      install_normalize_in_directory directory
    end
    
    def make_install_directory directory
      FileUtils.mkdir_p(directory)
    end
    
    def install_stylesheets_for_template_in_directory(template, directory)
      FileUtils.cp_r(stylesheets_directory_for_template(template), directory)
    end

    def install_scripts_for_template_in_directory(template, directory)
      FileUtils.cp_r(scripts_directory_for_template(template), directory)
    end
    
    def install_markup_for_template_in_directory(template, directory)
      FileUtils.cp_r(markup_files_for_template(template), directory)
    end

    def install_bourbon_in_directory directory
      install_path = File.join(directory, 'stylesheets', 'plugins')
      unless File.directory?(install_path)
        FileUtils.mkdir_p(install_path)
      end
      g = Bourbon::Generator.new([],{path: install_path})
      g.install
    end
        
    def install_neat_in_directory directory
      install_path = File.join(directory, 'stylesheets', 'plugins')
      unless File.directory?(install_path)
        FileUtils.mkdir_p(install_path)
      end
      ## Neat's install method doesn't allow you to set the path :(  
      #g = Neat::Generator.new([],{path: install_path})
      #g.install
      system("cd #{install_path} && neat install")
    end
    
    def install_bitters_in_directory directory
      ## Bitters doesn't name it's install directory bitters. It names it base by defualt.
      ## So we rename it to 'bitters' here.
      install_path = File.join(directory, 'stylesheets', 'plugins')
      unless File.directory?(install_path)
        FileUtils.mkdir_p(install_path)
      end
      g = Bitters::Generator.new([],{path: install_path})
      g.install
      FileUtils.mv(File.join(install_path, 'base'), File.join(install_path, 'bitters'), force: true)
    end
    
    def install_normalize_in_directory directory
      install_path = File.join(directory,
                               'stylesheets', 
                               'plugins')
      
      unless File.directory?(install_path)
        FileUtils.mkdir_p(install_path)
      end
      
      file_path = File.join(install_path, 'normalize.scss')
      
      normalize_url = 'https://raw.githubusercontent.com/necolas/normalize.css/master/normalize.css'
      File.open(file_path, 'wb') do |f|
        f.write open(normalize_url).read 
      end
    end
    
    def install_jquery_in_directory directory
      install_path = File.join(directory, 
                               'scripts', 
                               'lib', 
                               'plugins')
      
      unless File.directory?(install_path)
        FileUtils.mkdir_p(install_path)
      end
      
      file_path = File.join(install_path, 'jquery.min.js')
      
      jquery_url = 'https://code.jquery.com/jquery-3.0.0.min.js'
      File.open(file_path, 'wb') do |f|
        f.write open(jquery_url).read 
      end
    end
    
    def install_require_in_directory directory
      install_path = File.join(directory, 
                               'scripts', 
                               'lib',
                               'plugins')
      
      unless File.directory?(install_path)
        FileUtils.mkdir_p(install_path)
      end
      
      file_path = File.join(install_path, 'require.min.js')
      
      require_url = 'http://requirejs.org/docs/release/2.2.0/minified/require.js'
      File.open(file_path, 'wb') do |f|
        f.write open(require_url).read 
      end
    end

    def stylesheets_directory_for_template template
      File.join(templates_directory, template, 'stylesheets')
    end

    def scripts_directory_for_template template
      File.join(templates_directory, template, 'scripts')
    end
    
    def markup_files_for_template template
      template_directory = File.join(templates_directory, template)
      Dir["#{template_directory}/*.html"]
    end
    
    def templates_directory
      File.join(top_level_directory, 'core', 'whiskers')
    end

    def top_level_directory
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
  end
end