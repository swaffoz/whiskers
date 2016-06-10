require 'whiskers/generator'

whiskers_path = File.expand_path('../../core', __FILE__)
ENV['SASS_PATH'] = [
  ENV['SASS_PATH'],
  whiskers_path,
].compact.join(File::PATH_SEPARATOR)