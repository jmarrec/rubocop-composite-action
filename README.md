# Rubocop Composite Github Action

This action runs natively on the host instead of being in a docker. Internally it uses [setup-ruby](https://github.com/actions/setup-ruby) and [setup-python](https://github.com/actions/setup-python). Why `setup-python` you may ask: because I like python better than ruby, that's all.

It allows you to choose the `ruby-version` and the `rubocop-version` to be installed.

It will run rubocop, and use the github REST API to create a check-runs that will add annotations to your code where warning and failures where found.

The idea of using a composite action rather than a docker is it will pull ruby and python from the host's cache instead of having to build the docker, which should be faster.
Also, technically speaking, if you wanted to integrate this rubocop call into a workflow that runs on anything but linux it would work as well, whereas docker-based actions are limited
to Linux hosts.

## Usage

Here is an example workflow `rubocop.yml` that you could use in your project

```
name: Rubocop
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@v2

    - name: Run Rubocop
      uses: jmarrec/rubocop@v1
      with:
        ruby-version: '2.5'
        rubocop-version: '0.80.1'
```
