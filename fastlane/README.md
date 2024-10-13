fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios lint_podspec

```sh
[bundle exec] fastlane ios lint_podspec
```

Lint the podspec

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the project

### ios perform_tests

```sh
[bundle exec] fastlane ios perform_tests
```

Run tests for the pod library

### ios test

```sh
[bundle exec] fastlane ios test
```

Run lint, build, and tests for the pod library

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
