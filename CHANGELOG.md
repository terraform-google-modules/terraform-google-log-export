# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [11.1.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v11.0.0...v11.1.0) (2025-09-12)


### Features

* **deps:** Update Terraform Google Provider to v7 (major) ([#254](https://github.com/terraform-google-modules/terraform-google-log-export/issues/254)) ([c230974](https://github.com/terraform-google-modules/terraform-google-log-export/commit/c23097401d487c3297dc84aecf472f0175018a55))

## [11.0.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v10.0.0...v11.0.0) (2025-04-24)


### ⚠ BREAKING CHANGES

* update nodejs version in bq-log-alerting ([#249](https://github.com/terraform-google-modules/terraform-google-log-export/issues/249))
* **deps:** Update Terraform terraform-google-modules/scheduled-function/google to v6 ([#237](https://github.com/terraform-google-modules/terraform-google-log-export/issues/237))

### Bug Fixes

* **deps:** Update Terraform terraform-google-modules/scheduled-function/google to v6 ([#237](https://github.com/terraform-google-modules/terraform-google-log-export/issues/237)) ([e94ae41](https://github.com/terraform-google-modules/terraform-google-log-export/commit/e94ae41416f32d59ff35f495f0702b978e9f908a))
* update nodejs version in bq-log-alerting ([#249](https://github.com/terraform-google-modules/terraform-google-log-export/issues/249)) ([9089328](https://github.com/terraform-google-modules/terraform-google-log-export/commit/9089328d2ab8746fdf07079060e05cb5966bd656))

## [10.0.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v9.0.0...v10.0.0) (2024-09-20)


### ⚠ BREAKING CHANGES

* Terraform version 1.3+ required and allow max provider version 6.X ([#235](https://github.com/terraform-google-modules/terraform-google-log-export/issues/235))
* **TPG >= 5.27:** Add intercept_children support for log sinks ([#229](https://github.com/terraform-google-modules/terraform-google-log-export/issues/229))

### Features

* add support for expiration policy ttl in push topic subscriptio… ([#226](https://github.com/terraform-google-modules/terraform-google-log-export/issues/226)) ([59e738a](https://github.com/terraform-google-modules/terraform-google-log-export/commit/59e738ac6752533c22a51d76be7fbe1dd4c8cbda))
* **TPG >= 5.27:** Add intercept_children support for log sinks ([#229](https://github.com/terraform-google-modules/terraform-google-log-export/issues/229)) ([da7a7d4](https://github.com/terraform-google-modules/terraform-google-log-export/commit/da7a7d446321986aa18031371936da6cae48a7d1))


### Bug Fixes

* Terraform version 1.3+ required and allow max provider version 6.X ([#235](https://github.com/terraform-google-modules/terraform-google-log-export/issues/235)) ([4ad56e1](https://github.com/terraform-google-modules/terraform-google-log-export/commit/4ad56e18aaa2f92589bcfb03d3890a4e6e6db63e))

## [9.0.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v8.1.0...v9.0.0) (2024-08-16)


### ⚠ BREAKING CHANGES

* **TPG>=5.22:** added support for soft delete policy in storage sub-module ([#224](https://github.com/terraform-google-modules/terraform-google-log-export/issues/224))

### Features

* **TPG>=5.22:** added support for soft delete policy in storage sub-module ([#224](https://github.com/terraform-google-modules/terraform-google-log-export/issues/224)) ([05ea76f](https://github.com/terraform-google-modules/terraform-google-log-export/commit/05ea76f02d22ba456b7cc4fac5339d4722a96882))

## [8.1.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v8.0.0...v8.1.0) (2024-05-10)


### Features

* adding `description` argument to log sinks ([#212](https://github.com/terraform-google-modules/terraform-google-log-export/issues/212)) ([9caafe6](https://github.com/terraform-google-modules/terraform-google-log-export/commit/9caafe669019977af980de1ef42f7aac0928039f))

## [8.0.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.8.2...v8.0.0) (2024-02-23)


### ⚠ BREAKING CHANGES

* **deps:** Update Terraform terraform-google-modules/scheduled-function/google to v4 ([#205](https://github.com/terraform-google-modules/terraform-google-log-export/issues/205))

### Features

* adding `disabled` argument to log sinks ([#197](https://github.com/terraform-google-modules/terraform-google-log-export/issues/197)) ([aa797bc](https://github.com/terraform-google-modules/terraform-google-log-export/commit/aa797bcc6fdd6f2fa41500966eda459fdcb39db7))


### Bug Fixes

* **deps:** Update Terraform terraform-google-modules/scheduled-function/google to v4 ([#205](https://github.com/terraform-google-modules/terraform-google-log-export/issues/205)) ([48d9c58](https://github.com/terraform-google-modules/terraform-google-log-export/commit/48d9c58bd7885a4c017404506850481a3f19b687))

## [7.8.2](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.8.1...v7.8.2) (2024-01-11)


### Bug Fixes

* **CI:** move provider timeout to example ([#198](https://github.com/terraform-google-modules/terraform-google-log-export/issues/198)) ([d6fd7c8](https://github.com/terraform-google-modules/terraform-google-log-export/commit/d6fd7c827eeec8419ccd7cb7254b76cdb2fdde5d))

## [7.8.1](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.8.0...v7.8.1) (2024-01-11)


### Bug Fixes

* **CI:** increase provider timeout for bucket creation ([#195](https://github.com/terraform-google-modules/terraform-google-log-export/issues/195)) ([81f37d1](https://github.com/terraform-google-modules/terraform-google-log-export/commit/81f37d11aa512cf3b7838baf18b90688561f0964))
* **deps:** lints fixes for tflint ([#192](https://github.com/terraform-google-modules/terraform-google-log-export/issues/192)) ([6a0af59](https://github.com/terraform-google-modules/terraform-google-log-export/commit/6a0af599debc53871d53bccbc6b7b914950088f7))
* **deps:** Update dependency @google-cloud/bigquery to v7 ([#183](https://github.com/terraform-google-modules/terraform-google-log-export/issues/183)) ([0261a13](https://github.com/terraform-google-modules/terraform-google-log-export/commit/0261a1360538f6bbad4c57c6d425d943ef4ed6b2))
* **deps:** Update dependency crypto-js to v4 [SECURITY] ([#177](https://github.com/terraform-google-modules/terraform-google-log-export/issues/177)) ([c4fdd6d](https://github.com/terraform-google-modules/terraform-google-log-export/commit/c4fdd6d9ff801c0a5469bc89eb9c8fe7ac920d23))

## [7.8.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.7.0...v7.8.0) (2023-11-20)


### Features

* add lock in logging bucket ([#189](https://github.com/terraform-google-modules/terraform-google-log-export/issues/189)) ([fd276c3](https://github.com/terraform-google-modules/terraform-google-log-export/commit/fd276c307245d76f4b136e00df60572458b19316))
* adding cmek settings in log bucket ([#191](https://github.com/terraform-google-modules/terraform-google-log-export/issues/191)) ([d783b59](https://github.com/terraform-google-modules/terraform-google-log-export/commit/d783b596859e8d256f1b9459a6ef03ab9367b1a5))

## [7.7.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.6.0...v7.7.0) (2023-11-06)


### Features

* add support for Log Analytics in log bucket destination ([#179](https://github.com/terraform-google-modules/terraform-google-log-export/issues/179)) ([511585e](https://github.com/terraform-google-modules/terraform-google-log-export/commit/511585e81b5c3960c09415f266c9cb828a9e663d))
* enabling the storage submodule to allow public access prevention ([#181](https://github.com/terraform-google-modules/terraform-google-log-export/issues/181)) ([196eb71](https://github.com/terraform-google-modules/terraform-google-log-export/commit/196eb7174768aec2908650ff18bd672b423508bc))


### Bug Fixes

* update version constraints for TPG v5 ([#187](https://github.com/terraform-google-modules/terraform-google-log-export/issues/187)) ([63d105b](https://github.com/terraform-google-modules/terraform-google-log-export/commit/63d105b13903b5ea5b64d8e6bc955ecce01dc2d2))
* upgraded versions.tf to include minor bumps from tpg v5 ([#173](https://github.com/terraform-google-modules/terraform-google-log-export/issues/173)) ([659baba](https://github.com/terraform-google-modules/terraform-google-log-export/commit/659babaaac364512c2efbf33441ae339cd623451))

## [7.6.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.5.0...v7.6.0) (2023-06-22)


### Features

* Added support for custom placement config for Cloud Storage Bucket ([#160](https://github.com/terraform-google-modules/terraform-google-log-export/issues/160)) ([f896ebe](https://github.com/terraform-google-modules/terraform-google-log-export/commit/f896ebe4ca7c89974ddd6ca0a229c62b58e603ca))
* adding labels to pubsub_push_subscription resource ([#161](https://github.com/terraform-google-modules/terraform-google-log-export/issues/161)) ([917f371](https://github.com/terraform-google-modules/terraform-google-log-export/commit/917f371928d60512e8de94f541dd555ab6b2831d))

## [7.5.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.4.3...v7.5.0) (2023-03-29)


### Features

* added support for project as log exp destination ([#154](https://github.com/terraform-google-modules/terraform-google-log-export/issues/154)) ([36571cd](https://github.com/terraform-google-modules/terraform-google-log-export/commit/36571cd702355e851f7eecd005c2d3a79df88633))
* adds partition_expiration_days ([#143](https://github.com/terraform-google-modules/terraform-google-log-export/issues/143)) ([42876c4](https://github.com/terraform-google-modules/terraform-google-log-export/commit/42876c4826242ed44e69acc8b579847a4705e6bf))

## [7.4.3](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.4.2...v7.4.3) (2023-01-10)


### Bug Fixes

* **deps:** update tf modules ([#128](https://github.com/terraform-google-modules/terraform-google-log-export/issues/128)) ([c6375ef](https://github.com/terraform-google-modules/terraform-google-log-export/commit/c6375efd1c50427afa6bdc9d2bb9c2a733e471ea))
* fixes lint issues and generates metadata ([#136](https://github.com/terraform-google-modules/terraform-google-log-export/issues/136)) ([939d971](https://github.com/terraform-google-modules/terraform-google-log-export/commit/939d971ff98a28bbc9a6e82bdee2b6f0a7e49d2c))
* relax random provider version requirement ([#139](https://github.com/terraform-google-modules/terraform-google-log-export/issues/139)) ([3f7e6bb](https://github.com/terraform-google-modules/terraform-google-log-export/commit/3f7e6bba2bb63590df68d55245d16b7fd0970c69))

## [7.4.2](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.4.1...v7.4.2) (2022-08-09)


### Bug Fixes

* adds test assertion for log sink writer identity ([ef43513](https://github.com/terraform-google-modules/terraform-google-log-export/commit/ef4351399dffae3df6c2e46f61cc2acec1b30b7b))
* support logbucket sink in same project ([#118](https://github.com/terraform-google-modules/terraform-google-log-export/issues/118)) ([44758c2](https://github.com/terraform-google-modules/terraform-google-log-export/commit/44758c29c820d4c299e4c53e2ff08081d19e7f75))

## [7.4.1](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.4.0...v7.4.1) (2022-07-01)


### Bug Fixes

* adds iam for the log-sink writer id for the logbucket module ([545b1d7](https://github.com/terraform-google-modules/terraform-google-log-export/commit/545b1d792cb72b8d0d3ec59264adcf36f7256270))

## [7.4.0](https://github.com/terraform-google-modules/terraform-google-log-export/compare/v7.3.0...v7.4.0) (2022-06-01)


### Features

* adds log export blueprints for folder and organization ([3b4c8be](https://github.com/terraform-google-modules/terraform-google-log-export/commit/3b4c8be1a704d32f3aece1d5360e98a5884eb287))

## [7.3.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v7.2.0...v7.3.0) (2021-12-20)


### Features

* update TPG version constraints to allow 4.0 ([#108](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/108)) ([14320e9](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/14320e995ab4e91cb64bddbca06b66294056ab67))

## [7.2.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v7.1.0...v7.2.0) (2021-10-27)


### Features

* Support sink `exclusions` configuration ([#103](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/103)) ([1e07f65](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/1e07f65832efc2b0105d743b815bc8ed64828ab5))


### Bug Fixes

* Fix for day to ms conversion ([#107](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/107)) ([47f5148](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/47f51488639b3b885b80e8c6495bc8c66f610ea3))

## [7.1.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v7.0.0...v7.1.0) (2021-08-02)


### Features

* Added CMEK support for log sink destinations ([#101](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/101)) ([af0940c](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/af0940c8a27c93207712060222f1ad9177f81fd1))

## [7.0.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v6.0.2...v7.0.0) (2021-07-03)


### ⚠ BREAKING CHANGES

* Support lifecycle rules and labels for GCS submodule (#96)

### Features

* Support lifecycle rules and labels for GCS submodule ([#96](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/96)) ([1636eed](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/1636eed7d3ac6cb54d79d7849034a11613399dca))


### Bug Fixes

* correct version in upgrade guide ([#100](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/100)) ([fbc231a](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/fbc231a8f4025e30b442de30d7a7f9be0dbd34b7))

### [6.0.2](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v6.0.1...v6.0.2) (2021-06-03)


### Bug Fixes

* Apply subscriber role to subscription instead of topic ([#94](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/94)) ([0587a83](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/0587a8397d8c78a70a1f2e2d57d8f7f1944df852))

### [6.0.1](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v6.0.0...v6.0.1) (2021-05-10)


### Bug Fixes

* BigQuery Log Alerting ([#90](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/90)) ([d0e1a15](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/d0e1a154e197de9099d00c0636be7b8c6a049b85))
* Remove deprecated list() function. ([#92](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/92)) ([fcdfc9a](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/fcdfc9a9d3ef83b7a7999f5a6d1c4d440c281078))

## [6.0.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v5.2.0...v6.0.0) (2021-03-25)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#86)

### Features

* add Terraform 0.13 constraint and module attribution ([#86](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/86)) ([2b94062](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/2b940624854998c26d7fba59884c928d4d278745))
* Cloud Logging Alert Module ([#77](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/77)) ([84975c0](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/84975c0d74c7891b6cc52dcb2ceddcfe765b577f))

## [5.2.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v5.1.0...v5.2.0) (2021-03-05)


### Features

* Add subscriber_id variable to override the generated ID for the subscriber ([#84](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/84)) ([62ae776](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/62ae7763804547c62b3cc9515a8fb8ad54bb157f))

## [5.1.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v5.0.0...v5.1.0) (2020-12-08)


### Features

* Add storage module versioning support ([#75](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/75)) ([b38ec94](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/b38ec943f23c0e53dde25c88bd2b1e3e1cddaadb))


### Bug Fixes

* typo on documentation variable ([#71](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/71)) ([82b95b5](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/82b95b50abedb4338d199110f9bf1bdfc74b4ab4))

## [5.0.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v4.1.0...v5.0.0) (2020-10-16)


### ⚠ BREAKING CHANGES

* improvements to gcs and bigquery defaults (#64)
* replace bq expiration with expiration days for consistency with storage (#65)
* add support for expiration days in storage module (#63)

### Features

* Add retention policy support ([#68](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/68)) ([22b94a6](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/22b94a65cbcd87940789c7296f6bc1e5978a4c33))
* add support for expiration days in storage module ([#63](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/63)) ([add774a](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/add774ac1b7274a42a8c9bab8e466e53a64169aa))
* improvements to gcs and bigquery defaults ([#64](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/64)) ([5a3b925](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/5a3b9256344434b022416d4e69d122c7d2ccdf71))
* replace bq expiration with expiration days for consistency with storage ([#65](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/65)) ([a643101](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/a643101c8a08095524617d67f317ce7b7e6e78ab))


### Bug Fixes

* Bump provider version ([#61](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/61)) ([50c2f8f](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/50c2f8f11fbf76c5e38b4ce55003a3c26590f48f)), closes [#60](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/60)

## [4.1.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v4.0.1...v4.1.0) (2020-08-28)


### Features

* Add support for BigQuery partitioned tables ([#55](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/55)) ([aa71cdb](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/aa71cdb7d88e1273123ff0364aec6d47e83691da))


### Bug Fixes

* relax version constraints to enable terraform 0.13.x compatibility ([#57](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/57)) ([0f4a832](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/0f4a8320a55134fa52f8a0b23c9a4bc1055a7ee4))

### [4.0.1](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v4.0.0...v4.0.1) (2020-04-03)


### Bug Fixes

* Add necessary IAM permissions to Splunk Sink example ([#53](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/53)) ([b0b0619](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/b0b061996151b59e5002c3c7dc298a25128953a0))

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-log-export/compare/v3.2.0...v4.0.0) (2020-02-04)


### ⚠ BREAKING CHANGES

* Minimum Google provider version changed to 3.5.x

### Features

* Add the option to define 'bucket_policy_only' value on buckets ([#47](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/47)) ([702f411](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/702f4119429f30b23494f248232a2663a64f84b6))
* Upgrade to google-provider 3.5.x. ([#46](https://www.github.com/terraform-google-modules/terraform-google-log-export/issues/46)) ([311d603](https://www.github.com/terraform-google-modules/terraform-google-log-export/commit/311d603416c5dc70cfb3785a613054447ea3d7eb))

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
