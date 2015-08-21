# Base systemd tasks

## Usage

Add this line in `Capfile`:
```
require "capistrano/systemd"
```

## Tasks

* `systemd:setup` -- prepare systemd direcotires in the project directory.

## Variables

* `systemd_roles` -- what host roles uses systemd to run processes. Default value: `[:app, :db]`.
