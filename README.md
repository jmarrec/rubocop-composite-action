# Rubocop Composite Github Action

This action runs natively on the host instead of being in a docker. Internally it uses [setup-ruby](https://github.com/actions/setup-ruby) and [setup-python](https://github.com/actions/setup-python). Why `setup-python` you may ask: because I like python better than ruby, that's all.

It allows you to choose the `ruby-version` and the `rubocop-version` to be installed. **TODO**: Ideally this would have been part of the action itself, but composite actions **do not** support `uses` at the moment. **So you must use setup-ruby and setup-python yourself** before calling the action. [See actions/runner#646](https://github.com/actions/runner/issues/646)

It will run rubocop, and use the github REST API to create a check-runs that will add annotations to your code where warning and failures where found.

The idea of using a composite action rather than a docker is it will pull ruby and python from the host's cache instead of having to build the docker, which should be faster.
Also, technically speaking, if you wanted to integrate this rubocop call into a workflow that runs on anything but linux it would work as well, whereas docker-based actions are limited
to Linux hosts.

## Usage

Here is an example workflow `rubocop.yml` that you could use in your project. Note that you need Python 3.8+ as I'm using f-strings.

Note that if rubocop is already installed on your host, it will not install it again.

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

    - uses: actions/setup-ruby@v1
      with:
        ruby-version: 2.5

    - uses: actions/setup-python@v2
      with:
        python-version: 3.8

    - name: Run Rubocop
      uses: jmarrec/rubocop-composite-action@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        rubocop-version: '0.80.1'
        # ruby-version: '2.5'
```

There is also an `autocorrect` argument that will run `rubocop --auto-correct` first if set to `true`. Defaults to `false`.
If you set this to `true`, you can also use `commit-auto-correct` set to `true` to that the resulting auto-corrected files are pushed to your branch

Finally, a `use-bundle` argument is provided so the command run is `bundle exec rubocop` and not `rubocop`

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
    - name: Checkout for PR
      if: ${{ github.event_name == 'pull_request' }}
      uses: actions/checkout@v2
      with:
        ref: ${{ github.event.pull_request.head.sha }}  # Checkout the PR branch instead of the merge commit

    - name: Checkout for push
      if: ${{ github.event_name != 'pull_request' }}
      uses: actions/checkout@v2

    - uses: actions/setup-ruby@v1
      with:
        ruby-version: 2.5

    - uses: actions/setup-python@v2
      with:
        python-version: 3.8

    - name: Run rubocop
      id: rubocop
      uses: jmarrec/rubocop-composite-action@v1
      with:
        autocorrect: true
        commit-auto-correct: true
        use-bundle: true
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
