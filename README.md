# capistrano-systemd

This gem provides capistrano tasks that helps to manage Puma web server with systemd.

## Requirements

capistrano-systemd requires capistrano 3.x version.

## Installation

Add to `Gemfile`:
```
group :development do
  gem "capistrano", "~> 3.1"
  gem 'capistrano-systemd', github: "pvlltvk/capistrano-systemd"
end
```

Run:
```
$ bundle
```

## Usage

See documention for each module below.

## Modules

* [Base tasks](/lib/capistrano/systemd/README.md)
* [Puma](/lib/capistrano/puma/README.md)
