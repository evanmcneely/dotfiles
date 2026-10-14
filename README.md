# Dotfiles

Likely only works on macOS but 🤷.

## Usage

Run the command `stow <pkg name>` with the name of the package you want to use (requires [stow](https://www.gnu.org/software/stow/)).

## Fresh setup

Todo

## Neovim diffs

The Zsh helper `gdiff` (aliased to `dv`) launches Neovim directly into Diffview:

```sh
dv                              # Current working-tree changes
dv --cached                     # Staged changes
dv HEAD                         # All tracked changes against HEAD
dv main...HEAD                   # Branch changes since the merge base
dv HEAD~1..HEAD                  # Last commit
dv -- 'path/to/file with spaces' # Limit the diff to a path
dv --vertical                   # Force top/bottom panes
dv --horizontal --cached        # Force side-by-side panes
```

`dv` chooses top/bottom below 140 terminal columns and side-by-side otherwise.
The layout is selected at startup; resizing does not automatically switch it.
Use `--vertical` or `--horizontal` before `--` to override the automatic choice.

Arguments follow `:help DiffviewOpen`: use `A..B` to compare two revisions.
Diffview supports Git-style revisions, `--cached` / `--staged`, and pathspecs,
but not every `git diff` flag (such as `--stat` or `--word-diff`).
Run `:qa` to exit Neovim.

## Other

Firenvim [Chorme plugin](https://chromewebstore.google.com/detail/egpjdkipkomnmjhjmdamaniclmdlobbo)
[Add](https://intelephense.com/faq.html) Intelephense License Key
Import Raycast settings and data
