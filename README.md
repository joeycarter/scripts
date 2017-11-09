# My Scripts

[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/joeycarter/scripts/blob/master/LICENSE)

A collection of useful scripts for working at CERN and elsewhere.

## Installing

```bash
$ source setup.sh
```

Executing the setup script adds this repository to your `PATH` and prompts you for your CERN username. If you have have a CERN login, enter it here; your username will be saved to `.username`. Otherwise, hit enter. Obviously if you don't have a CERN login you won't be able to use the scripts that require one.

## Note

These scripts are designed for use with the `zsh` shell (I really like `zsh`, you should try it and also check out [`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh)). You'll see that most (if not all) of my scripts begin with the `#!/bin/zsh` shebang. That being said, most of the scripts should work if you use `bash`.
