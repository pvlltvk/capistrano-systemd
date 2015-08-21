Dir.glob(File.expand_path("../systemd/*.rake", __FILE__)) do |file|
  load file
end
