# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- Migrated to Google Provider version 3.5.x [#45]

## [3.2.0] - 2019-12-12

### Added
- Added support for creating push subscribers on PubSub, via `create_push_subscriber`. [#43]
- Added [Datadog integration example](./examples/datadog-sink) [#43]

## [3.1.1] - 2019-12-10

### Fixed

- The correct name for the BigQuery service. [#39]

## [3.1.0] - 2019-10-23

### Added
- Fields description, labels and default_table_expiration_ms [#36]

### Changed

- Migrated to Cloud Build. [#33]

## [3.0.0] - 2019-07-23

### Changed

- Migrated to Terraform 0.12. [#22]

## [2.3.0] - 2019-06-03

### Added

- Variable for labels on the Pub/Sub topic. [#19]

## [2.2.0] - 2019-05-29

### Added

- Variable for toggling destruction of BigQuery dataset contents. [#18]

## [2.1.0] - 2019-05-29

### Added

- Variables for location and storage class. [#16]

## [2.0.0] - 2019-04-05
### Added
- Kitchen-terraform tests for log exports at the project/folder/organization level and for storage/PubSub/BigQuery destinations
- Submodules for each destination (storage/PubSub/BigQuery)

### Changed
- Module structure from single monolithic module creating log exports and destinations to a root module for the log export and submodules for each destination
- There are now individual outputs for each module instead of a map of values
- Updated README with new module declaration format and added information on testing
- Pinned Google Terraform provider to version 2.0 in all examples

## [1.0.0] - 2018-09-26
### Added
- Initial release of log export module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v3.2.0...HEAD
[3.2.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v3.1.1...v3.2.0
[3.1.1]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v3.0.0...v3.1.0
[3.0.1]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v2.3.0...v3.0.0
[2.3.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-log-export/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-log-export/releases/tag/v1.0.0

[#43]: https://github.com/terraform-google-modules/terraform-google-log-export/pull/43
[#39]: https://github.com/terraform-google-modules/terraform-google-log-export/issues/39
[#33]: https://github.com/terraform-google-modules/terraform-google-log-export/pull/33
[#22]: https://github.com/terraform-google-modules/terraform-google-log-export/pull/22
[#19]: https://github.com/terraform-google-modules/terraform-google-log-export/pull/19
[#18]: https://github.com/terraform-google-modules/terraform-google-log-export/pull/18
[#16]: https://github.com/terraform-google-modules/terraform-google-log-export/pull/16
