# .files

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

#### Legend

- `⌘` Command
- `⌥` Option/Alt
- `⌃` Control
- `⇧` Shift
