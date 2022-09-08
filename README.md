<div align="center">

# asdf-difftastic [![Build](https://github.com/volf52/asdf-difftastic/actions/workflows/build.yml/badge.svg)](https://github.com/volf52/asdf-difftastic/actions/workflows/build.yml) [![Lint](https://github.com/volf52/asdf-difftastic/actions/workflows/lint.yml/badge.svg)](https://github.com/volf52/asdf-difftastic/actions/workflows/lint.yml)


[difftastic](https://github.com/volf52/difftastic) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add difftastic
# or
asdf plugin add difftastic https://github.com/volf52/asdf-difftastic.git
```

difftastic:

```shell
# Show all installable versions
asdf list-all difftastic

# Install specific version
asdf install difftastic latest

# Set a version globally (on your ~/.tool-versions file)
asdf global difftastic latest

# Now difftastic commands are available
difft --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/volf52/asdf-difftastic/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Arslan](https://github.com/volf52/)
