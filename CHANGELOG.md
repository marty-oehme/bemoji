# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add default support for `ilia` gtk-based picker tool, used by default in Regolith Linux

<!-- ### Changed -->

<!-- ### Deprecated -->

<!-- ### Removed -->

<!-- ### Fixed -->

<!-- ### Security -->

## [0.3.0] - 2022-11-10

### Added

- Add new option `-n` which suppresses printing the final newline character in output

### Changed

- Multiple command options can be combined
- Allow downloading emoji sets at any time after initial run with `-D <choice>`

### Fixed

- Custom default command is only executed when no command option given
- Results are matched case insensitively when using rofi picker to match other pickers

## [0.2.0] - 2022-06-29

### Added

- Display of configuration options on `-v` toggle
- AUR installation instructions

### Changed

- Simplified grep invocation to adhere more closely to POSIX

### Fixed

- Custom picker, clipper, and typer command invocation quoting
