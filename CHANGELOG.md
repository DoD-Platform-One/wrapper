# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [0.4.11] - 2024-12-23

### Changed

- Added helm lookup for allow-all-in-namespace auth policy to ensure it is only installed once per namespace

## [0.4.10] - 2024-07-09

### Changed

- Changed the default istio hardening state to istio's default
- Added the maintenance track annotation and badge

## [0.4.9] - 2024-06-20

### Changed

- Removed the allow nothing policy
- Renamed the istio authorization policies
- Added the IstioHardened doc

## [0.4.8] - 2024-05-28

### Changed

- Fixed the ingressgateway authorization policy

## [0.4.7] - 2024-04-03

### Changed

- Made the ingress policy match all workloads if no matchlabels are provided

## [0.4.6] - 2024-02-27

### Changed

- Added support for multiple domains
- Removed value package.istio.hosts[*].domain

## [0.4.5] - 2024-02-14

### Changed

- Added istio `allow-intra-namespace` authorization policy

## [0.4.4] - 2024-01-04

### Changed

- Fixed outstanding issues for multiple istio gateway network policies
- Fixed an issue with tempo support in istio sidecar network policies

## [0.4.3] - 2023-12-22

### Changed

- Fixed support for multiple istio gateway network policies

## [0.4.2] - 2023-11-1

### Added

- Added istio `allow-nothing` policy
- Added istio `allow-ingress` polic(y|ies)
- Added istio custom policy template

## [0.4.1] - 2023-04-19

### Changed

- Default value for secrets/configmaps
- Template for secrets/configmaps to operate over a list

## [0.4.0] - 2023-04-10

### Changed

- Template for custom dashboards

## [0.3.0] - 2023-04-07

### Changed

- Changed istio.injection value to be a string enabled/disabled for consistency

## [0.2.1] - 2023-03-29

### Changed

- SSO comment updated for clarity

## [0.2.0] - 2023-03-29

### Changed

- Template for additional networkpolicies

## [0.1.1] - 2023-02-24

### Changed

- Hot fix for tempo egress policy

## [0.1.0] - 2023-02-14

### Changed

- Updated chart name and source

## [0.0.2] - 2022-11-30

### Changed

- Fixed issue with podselector default for metrics networkpolicy

## [0.0.1] - 2022-11-18

### Added

- Initial chart
