#!/usr/bin/env bash
# Enhanced prompt for Bash
# - shows username only (no hostname) in calm blue with a subtle glow
# - prints full path (home shortened to ~)
# - shows git branch (with dirty marker)
# - prints a directory listing when you change directories

_PREV_PWD=""

_calm_colors() {
  RESET='\[\e[0m\]'
  BOLD='\[\e[1m\]'
  CALM_BLUE='\[\e[38;2;120;170;255m\]'
  GLOW='\[\e[38;2;160;200;255m\]'
  FG='\[\e[38;2;230;230;230m\]'
}

_short_pwd() {
  local d="${PWD/#$HOME/~}"
  printf "%s" "$d"
}

_git_branch() {
  local b
  b=$(git -C "$PWD" rev-parse --abbrev-ref HEAD 2>/dev/null) || return 0
  local dirty=""
  if ! git -C "$PWD" diff --quiet --ignore-submodules -- 2>/dev/null || ! git -C "$PWD" diff --cached --quiet --ignore-submodules -- 2>/dev/null; then
    dirty="*"
  fi
  printf "%s%s" "$b" "$dirty"
}

_print_dir_and_listing() {
  # Only print when directory changed to avoid flooding every prompt
  if [ "$PWD" != "$_PREV_PWD" ]; then
    _PREV_PWD="$PWD"
    local dir
    dir=$(_short_pwd)
    printf "%b\n" "${CALM_BLUE}${BOLD}${dir}${RESET}"
    # Compact colorized listing; change to -la if you prefer long listing
    ls --color=auto -C
  fi
}

_set_ps1() {
  _calm_colors
  local dir
  dir=$(_short_pwd)
  local branch
  branch=$(_git_branch)
  local git_seg=""
  if [ -n "$branch" ]; then
    git_seg=" ${GLOW}(${branch})${RESET}"
  fi
  PS1="${GLOW}${BOLD}elbulbol${RESET} ${CALM_BLUE}${dir}${RESET}${git_seg}\n${GLOW}❯ ${RESET}"
}

_update_prompt() {
  _print_dir_and_listing
  _set_ps1
}

PROMPT_COMMAND=_update_prompt

# To enable automatically, add this line to your ~/.bashrc:
#   source "$HOME/.config/foot/prompt.sh"
