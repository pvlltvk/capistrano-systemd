namespace :systemd do
  desc "Setup systemd directories"
  task :setup do
    on roles(fetch(:systemd_roles)) do
      within fetch(:deploy_to) do
        if test "[ ! -d #{deploy_to}/systemd ]"
          execute :mkdir, "-v", "#{deploy_to}/systemd"
        else
          info "Directory 'systemd' already exists"
        end
        %w(.env available enabled).each do |subdir|
          if test "[ ! -d #{deploy_to}/systemd/#{subdir} ]"
            execute :mkdir, "-v", "#{deploy_to}/systemd/#{subdir}"
          else
            info "Directory 'systemd/#{subdir}' already exists"
          end
        end

        execute "echo $HOME > #{deploy_to}/systemd/.env/HOME"
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :systemd_roles, fetch(:systemd_roles, [:app, :db])
  end
end
