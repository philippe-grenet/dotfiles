# # Project: Dot Files

## What this repo is

This repository is contains (most of) my dot files, including:
- zsh configuration (`.zshrc`, `.zsh` directory)
- git configuration (`.gitconfig`)
- Hammerspoon configuration (`init.lua`)

There are symbolic links in my home directory to files in this repo.

This is supposed to be cross-machines, between home and work computers.

## Shell Scripting Conventions

- New shell scripts go in the existing `bin/` directory, and new zsh function go into
  the `.zsh/fn/` directory — do NOT create new lib/ or helper directories.
- Never use `local path` in zsh functions (it shadows and wipes $PATH). Use `local
  target` / `local dest` instead.
- Be careful with `${var//a/b}` when the pattern contains `/` — use an alternate
  delimiter or a temp variable.
- Always live-test a new script on a real file before reporting it as done.
- When rewriting prompt strings, config lines, or anything containing Nerd Font glyphs /
  box-drawing / emoji characters, preserve the original bytes exactly and diff-check the
  glyphs before reporting done.
