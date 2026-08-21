# dotfiles

Philippe's backup of zsh configuration and other things.

## Hammerspoon Configuration

This repository contains a Hammerspoon configuration (`init.lua`) for macOS window
management and application launching.

### Keyboard Shortcuts

#### Window Positioning

| Shortcut | Description                                                         |
|----------|---------------------------------------------------------------------|
| `⌘⌥←`    | Move window to left half of screen                                  |
| `⇧⌘⌥←`   | Move window to left 1/3 of screen                                   |
| `⌘⌥→`    | Move window to right half of screen                                 |
| `⇧⌘⌥→`   | Move window to right 1/3 of screen                                  |
| `⌘⌥↑`    | Maximize window vertically (preserve horizontal position and width) |
| `⌘⌥↓`    | Center window horizontally at half screen width (full height)       |

#### Multi-Monitor Support

| Shortcut | Description                                                |
|----------|------------------------------------------------------------|
| `⌘⌥1`    | Move window to screen 1 (preserves relative position/size) |
| `⌘⌥2`    | Move window to screen 2 (preserves relative position/size) |
| `⌘⌥3`    | Move window to screen 3 (preserves relative position/size) |

Screens are ordered deterministically from left-to-right, then top-to-bottom.

#### Application Launchers

| Shortcut | Application        |
|----------|--------------------|
| `⌃⌥⌘D`   | Dictionary         |
| `⌃⌥⌘C`   | Calendar           |
| `⌃⌥⌘E`   | Emacs              |
| `⌃⌥⌘T`   | iTerm              |
| `⌃⌥⌘S`   | Safari             |
| `⌃⌥⌘G`   | Google Chrome      |
| `⌃⌥⌘V`   | Visual Studio Code |
| `⌃⌥⌘K`   | Slack              |
| `⌃⌥⌘I`   | IntelliJ IDEA CE   |

#### Window Management

| Shortcut | Description                             |
|----------|-----------------------------------------|
| `⌃⌥⌘W`   | Minimize all visible windows            |
| `⇧⌃⌥⌘W`  | Restore last batch of minimized windows |

#### Org Capture

| Shortcut  | Description                                     |
|-----------|-------------------------------------------------|
| `⌃⌥⌘F12`  | Capture to the Org Inbox from anywhere in macOS |
| `⇧⌃⌥⌘F12` | Same, but with the full capture template menu   |

Pops a small Emacs frame, centered on the screen holding the focused window, to run
`org-capture`. The frame closes itself once the capture is finalized (`C-c C-c`),
killed (`C-c C-k`), refiled (`C-c C-w`) or aborted (`C-g`).

The Emacs half lives in `~/.emacs.d/taps/org-mode/org-capture-frame.el`; this config
only binds the hotkey and calls it through `emacsclient`, passing the screen rectangle
to center in. It needs the Emacs server to be running — if it is not, the failure is
reported as an on-screen alert.

#### Legend

- `⌘` Command
- `⌥` Option/Alt
- `⌃` Control
- `⇧` Shift

## Zsh

`.zshrc`, the prompt in `.zsh/prompt`, and the functions in `.zsh/fn/` — every file in
that directory is sourced at startup, one function per file.

### Functions

| Function                          | Description                                                                              |
|-----------------------------------|------------------------------------------------------------------------------------------|
| `cdr`                             | cd to the root of the current git repo                                                   |
| `g <dir>`                         | cd to `<dir>` if it sits anywhere between here and the repo root; lists the candidates when ambiguous |
| `build`                           | cd to the CMake build directory of the current repo (`cmake.bld/$(uname)`)               |
| `y`                               | Yazi wrapper that leaves the shell in the directory you exited from (`q` changes it, `Q` does not) |
| `stale [-m N] [-d N] [-n] [dir]`  | Interactively trash files not modified in the last N months (3 by default), picked with fzf; `--help` for options, `?` in the picker for keys |
| `mvdoc <file> <destination>`      | Move an org or Markdown file together with the images and diagrams it links to, rewriting the links that would otherwise break; shows a plan and asks before touching anything (`--help` for options) |
| `backup <dir>`                    | Encrypt `<dir>` into `<dir>.enc` in the current directory (tar + AES-256)                |
| `restore <dir>.enc`               | Restore an archive made by `backup`, refusing to overwrite an existing directory          |
| `save <file>`                     | Copy `<file>` to `~/Scratch`                                                             |
| `em [file...]`                    | Start the Emacs daemon if none is running, then open a client frame                      |
| `killem`                          | Kill the Emacs daemon                                                                    |
| `bbproxy [on\|off]`               | Turn the Bloomberg proxy on or off; with no argument, print its status                   |
| `bootstrap`                       | Download and run the Bloomberg mac bootstrap                                             |
| `ssh-dev <machine>`               | ssh to a dev machine through the dev gateway                                             |
| `last-reboot`                     | Time since the last reboot, colored green / orange / red past 5 and 7 days               |
| `claude`                          | Run Claude Code in a scrubbed environment, with the proxy unset                          |

`repo-named-dir` defines no command: it registers a zsh dynamic named directory, so
`~[r]` expands to the root of the current git repo (`cd ~[r]/src`, `ls ~[r]`).

### Key bindings

| Shortcut    | Description                                                              |
|-------------|--------------------------------------------------------------------------|
| `C-x C-e`   | Edit the current command line in Emacs                                   |
| `TAB`       | Accept the autosuggestion when one is shown, otherwise fzf completion    |
| `⌥←` / `⌥→` | Move backward / forward one word                                         |

The line editor uses Emacs bindings (`bindkey -e`) regardless of `$EDITOR`.

### Aliases

| Alias                                  | Description                                          |
|----------------------------------------|------------------------------------------------------|
| `ls` / `la` / `ll`                     | GNU `ls` with color, `-a`, `-l`                      |
| `cls`                                  | Clear the screen and the scrollback                  |
| `epurge`                               | Delete Emacs backup files (`*~`) in the current dir  |
| `fzfp`                                 | fzf with a `bat` preview of the highlighted file     |
| `bootime`                              | Boot time, from `system_profiler`                    |
| `lsusb`                                | List USB devices                                     |
| `getprodwin`                           | Get the current PRQS production window               |
| `ftpdev`                               | sftp to devsftp with the toolkit key                 |
| `apache-start` / `-stop` / `-restart`  | Control the Homebrew Apache                          |
| `unsecure-chrome`                      | Chrome with web security off, for CORS testing       |
| `spark-shell-color`                    | `spark-shell` with Scala colors enabled              |

### Notable settings

- History: 10k lines in `~/.zsh_history`, appended rather than replaced so parallel
  sessions do not clobber each other.
- `zsh-autosuggestions` and `zsh-syntax-highlighting`, from Homebrew.
- `fzf` (Catppuccin Mocha colors) and `zoxide`.
- GNU coreutils are put ahead of the BSD ones on the `PATH`.
- The Bloomberg proxy is turned on automatically, and `~/.lcldevrc` sourced, only on the
  work machine — everything gated on `$ATBB`, which tests the hostname.

### Known rough edges

- `$EMACS` is never set anywhere in these files, so `alias ez=$EMACS` expands to nothing
  and `em` cannot start a daemon when none is running (it works when one already is).
- `.gitconfig` sets `core.editor` to `/home/pgrenet/bin/emc`, a Linux path that does not
  exist on the Mac. It is masked in interactive shells by the exported `GIT_EDITOR`.

## Git

`.gitconfig`, plus the delta theme in `delta-catppuccin.gitconfig`.

### Aliases

| Alias                              | Description                                                                                   |
|------------------------------------|-----------------------------------------------------------------------------------------------|
| `git alias`                        | List every alias defined here                                                                 |
| `git st` / `br` / `co`             | `status` / `branch` / `checkout`                                                              |
| `git lg`                           | One-line log: abbreviated hash, relative date, subject, author, refs                          |
| `git last`                         | The same format, for the last commit only                                                     |
| `git first`                        | The repo's very first commit                                                                  |
| `git origin`                       | URL of the `origin` remote                                                                    |
| `git credit`                       | Authors ranked by the number of lines blamed on them                                          |
| `git uncommit`                     | Undo the last commit, keeping all its changes unstaged                                        |
| `git syncfork <branch>`            | Fetch `upstream`, merge `upstream/<branch>`, push to `origin`                                 |
| `git pr <n> [remote]`              | Fetch PR `<n>` into local branch `pr/<n>` and check it out (from `upstream` if it exists, else `origin`) |
| `git pr-clean`                     | Delete every local `pr/*` branch                                                              |
| `git pr-worktree <n> [remote]`     | Like `git pr`, but checks the PR out in a worktree at `../<repo>-pr<n>`                       |
| `git new-worktree <branch> [base]` | Create `<branch>` and a worktree for it at `../<repo>-<branch>`, based on `base` (default `HEAD`) |
| `git Kompare`                      | difftool using kompare                                                                        |

### Notable settings

- [delta](https://dandavison.github.io/delta/) as the pager, side-by-side, Catppuccin Mocha.
- `bbgithub:` is a shorthand for the internal GitHub, rewritten to ssh on push and pull.
  The extra `url` and `github` blocks are what let Emacs forge recognize those URLs.
- Credentials come from `gh auth git-credential`, for both github.com and bbgithub.
- `forge.remote = upstream`, `pull.rebase = false`, `init.defaultBranch = main`.
