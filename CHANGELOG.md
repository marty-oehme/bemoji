# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add new option `-n` which suppresses printing the final newline character in output

### Changed

- Multiple command options can be combined
- (!) History uses `XDG_STATE_HOME` directory by default:
  This constitutes a break in behavior if you relied a lot on your pick history in the default
  location. To retain your old history file, simply move it from the old cache directory
  (`~/.cache/bemoji-history.txt` by default) to the new one (`~/.local/state/bemoji-history.txt`
  by default).
- (!) `XDG_CACHE_LOCATION` renamed to `XDG_HISTORY_LOCATION` to better signify its purpose

<!-- ### Deprecated -->

<!-- ### Removed -->

### Fixed

- Custom default command is only executed when no command option given
- Results are matched case insensitively when using rofi picker to match other pickers

<!-- ### Security -->

## [0.2.0] - 2022-06-29

### Added

- Display of configuration options on `-v` toggle
- AUR installation instructions

### Changed

- Simplified grep invocation to adhere more closely to POSIX

### Fixed

- Custom picker, clipper, and typer command invocation quoting
