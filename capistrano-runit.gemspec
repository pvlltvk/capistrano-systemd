Gem::Specification.new do |s|
  s.name        = "capistrano-systemd"
  s.version     = "2.0.0"
  s.summary     = "Capistrano recipes to manage systemd services"
  s.homepage    = "https://github.com/pvlltvk/capistrano-systemd"
  s.author      = ["Pavel Litvyak"]
  s.email       = ["pvlltvk@gmail.com"]
  s.license     = "MIT"

  s.files         = `git ls-files`.split($/)
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capistrano", "~> 3.0"
  s.add_runtime_dependency "sshkit", "~> 1.3"
end
