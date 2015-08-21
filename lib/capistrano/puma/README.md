# Puma

## Usage

Add this line in `Capfile`:
```
require "capistrano/puma"
```

## Tasks

* `systemd:puma:setup` -- setup puma systemd service.
* `systemd:puma:enable` -- enable and autostart service.
* `systemd:puma:disable` -- stop and disable service.
* `systemd:puma:start` -- start service.
* `systemd:puma:status` -- service status.
* `systemd:puma:stop` -- stop service.
* `systemd:puma:restart` -- restart service.
* `systemd:puma:phased_restart` -- run phased restart.
* `systemd:puma:change_config` -- change puma config.

## Variables

* `systemd_puma_config_template` -- path to ERB template of `puma.rb` file. Default value: internal default template (`lib/capistrano/systemd/templates/puma.erb`).
* `systemd_puma_run_template` -- path to ERB template of `run` file. Default value: internal default template (`lib/capistrano/systemd/templates/run-puma.erb`).
* `systemd_puma_workers` -- number of puma workers. Default value: 1.
* `systemd_puma_threads_min` -- minimal threads to use. Default value: 0.
* `systemd_puma_threads_max` -- maximal threads to use. Default value: 16.
* `systemd_puma_bind` -- bind URI. Examples: tcp://127.0.0.1:8080, unix:///tmp/puma.sock. Default value: nil.