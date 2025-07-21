## dotfiles

This repo holds Aimee's dotfiles--configs for her commonly used CLI programs.

### installation

1. Clone the repo on a Linux or macOS or WSL machine.
2. Run `./setup.sh` to symlink files from the repo directory into the expected
   locations under `$HOME`.

#### usage/options

`% ./setup [-v] [-s CHECKOUT_PATH] [-d INSTALL_PATH]`

* `-v` increases verbosity of logs
* -s `CHECKOUT_PATH` is the source directory the dotfiles repo was cloned to (defaults to current directory).
* -d `INSTALL_PATH` base path to symlink configs into (defaults to `$HOME`).

Paths can also be specified by environment variable.
