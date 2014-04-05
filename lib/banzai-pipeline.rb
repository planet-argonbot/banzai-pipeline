if defined?(Capistrano::VERSION)
  if Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
    recpie_version = 3
  end
end

recipe_version ||= 2
load File.expand_path("../capistrano/tasks/assets_v#{recipe_version}.rake", __FILE__)
