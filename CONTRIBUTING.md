# Contributing

This repository uses the following conventions:

* [Semantic Versioning](https://semver.org/)
* [Keep a Changelog](https://keepachangelog.com/)
* [Conventional Commits](https://www.conventionalcommits.org/)

Development requires the following tools

* [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [helm](https://helm.sh/docs/intro/install/)
* [fluxcd](https://fluxcd.io/docs/installation/)

To contribute a change:

1. Open an issue in GitLab describing the scope of your work
1. Assign yourself to the issue
1. Label the issue with `status::doing`
1. Create a branch in the repository
1. Make changes in code and push to your branch
1. If necessary, update tests to cover your changes.
1. Make commits using the [Conventional Commits](https://www.conventionalcommits.org/) format
1. Update `CHANGELOG.md` using the [Keep a Changelog](https://keepachangelog.com) format
1. Open a merge request into the `main` branch
1. Add a reference to the issue in the merge request description
1. Resolve any failures from the pipeline
1. Resolve any merge conflicts
1. Label the Merge Request with `status::review`
1. Contact the code owners to expedite your Merge Request review
1. Address any review comments and merge conflicts during the review process
1. Wait for a code owner to approve and merge your changes
1. After the merge, verify that a release and tag were created
1. Make a change in the [Big Bang](https://repo1.dso.mil/platform-one/big-bang/bigbang) values to use the new tag
