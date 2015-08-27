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
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :systemd_roles, fetch(:systemd_roles, [:app, :db])
  end
end
