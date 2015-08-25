require "erb"

namespace :systemd do
  namespace :puma do
    task :map_bins do
      if Rake::Task.task_defined?("bundler:map_bins")
        fetch(:bundle_bins).push "puma"
      end
      if Rake::Task.task_defined?("rbenv:map_bins")
        fetch(:rbenv_map_bins).push "puma"
      end
    end

    if Rake::Task.task_defined?("bundler:map_bins")
      before "bundler:map_bins", "systemd:puma:map_bins"
    end
    if Rake::Task.task_defined?("rbenv:map_bins")
      before "rbenv:map_bins", "systemd:puma:map_bins"
    end

    desc "Setup puma systemd service"
    task :setup do
      # requirements
      if fetch(:systemd_puma_bind).nil?
        $stderr.puts "You should set 'systemd_puma_bind' variable."
        exit 1
      end

      on roles(:app) do |host|
        if test "[ ! -d #{deploy_to}/systemd/available ]"
          execute :mkdir, "-v", "#{deploy_to}/systemd/available"
        end
        if test "[ ! -d #{shared_path}/tmp/puma ]"
          execute :mkdir, "-v", "#{shared_path}/tmp/puma"
        end
        service_template_path = fetch(:systemd_puma_service_template)
        if !service_template_path.nil? && File.exist?(service_template_path)
          service_template = ERB.new(File.read(service_template_path))
          service_stream = StringIO.new(service_template.result(binding))
          upload! service_stream, "#{deploy_to}/systemd/available/puma-#{fetch(:application)}.service"
	  within "#{deploy_to}/current" do
	    rvm_current = capture(:rvm, 'current')
	    execute :rvm, "wrapper", "#{rvm_current}", "#{fetch(:application)} pumactl"
          end
        else
          error "Template from 'systemd_puma_service_template' variable isn't found: #{service_template_path}"
        end

    config_template_path = fetch(:systemd_puma_config_template)
    if !config_template_path.nil? && File.exist?(config_template_path)
          config_template = ERB.new(File.read(config_template_path))
          config_stream = StringIO.new(config_template.result(binding))
          upload! config_stream, "#{deploy_to}/systemd/puma.rb"
        else
          error "Template from 'config_puma_template' variable isn't found: #{config_template_path}"
        end

      end
    end

    desc "Change puma config"
    task :change_config do
      on roles(:app) do |host|
        if test "[ -f #{deploy_to}/systemd/puma.rb ]"
          execute :rm, "-f", "{deploy_to}/systemd/puma.rb}"
          config_template_path = fetch(:systemd_puma_config_template)
          if !config_template_path.nil? && File.exist?(config_template_path)
            config_template = ERB.new(File.read(config_template_path))
            config_stream = StringIO.new(config_template.result(binding))
            upload! config_stream, "#{deploy_to}/systemd/puma.rb"
          else
            error "Template from 'config_puma_template' variable isn't found: #{config_template_path}"
          end
        else
          error "Puma config isn't found. You should run systemd:puma:setup."
        end
      end
    end

    desc "Enable puma systemd service"
    task :enable do
      on roles(:app) do |host|
        if test "[ -f #{deploy_to}/systemd/available/puma-#{fetch(:application)}.service ]"
          within "#{deploy_to}/systemd/enabled" do
            execute :ln, "-sf", "../available/puma-#{fetch(:application)}.service", "puma-#{fetch(:application)}.service"
	  end
	  execute :ln, "-sf", "#{deploy_to}/systemd/available/puma-#{fetch(:application)}.service", "/etc/systemd/system/puma-#{fetch(:application)}.service"
	  execute "sudo systemctl enable puma-#{fetch(:application)}.service"
	else
          error "Puma systemd service isn't found. You should run systemd:puma:setup."
        end
      end
    end

    desc "Disable puma systemd service"
    task :disable do
      invoke "systemd:puma:stop"
      on roles(:app) do
        if test "[ -d #{deploy_to}/systemd/enabled/puma-#{fetch(:application)}.service ]"
          execute :rm, "-f", "#{deploy_to}/systemd/enabled/puma-#{fetch(:application)}.service"
          execute "systemctl disable puma-#{fetch(:application)}.service"
        else
          error "Puma systemd service isn't enabled."
        end
      end
    end

    %w[start stop restart status].each do |command|
    desc "#{command} Puma server."
    task command do
      on roles(:app) do
        if test "[ -d #{deploy_to}/systemd/enabled/puma-#{fetch(:application)}.service ]"
          execute "systemctl #{command} puma-#{fetch(:application)}.service"
        else
          error "Puma systemd service isn't enabled."
        end
      end
    end

    desc "Run phased restart puma systemd service"
    task :phased_restart do
      on roles(:app) do
        if test "[ -d #{deploy_to}/systemd/enabled/puma-#{fetch(:application)}.service ]"
          execute "systemctl reload puma-#{fetch(:application)}.service"
        else
          error "Puma systemd service isn't enabled."
        end
      end
    end
  end
end
end

namespace :load do
  task :defaults do
    set :systemd_puma_service_template, File.expand_path("../puma.service.erb", __FILE__)
    set :systemd_puma_config_template, File.expand_path("../puma.erb", __FILE__)
    set :systemd_puma_workers, 1
    set :systemd_puma_threads_min, 0
    set :systemd_puma_threads_max, 16
    set :systemd_puma_bind, nil
  end
end