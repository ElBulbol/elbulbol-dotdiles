#!/usr/bin/env bash
# Enhanced prompt for Bash
# - shows username only (no hostname) in calm blue with a subtle glow
# - prints full path (home shortened to ~)
# - shows git branch (with dirty marker)




_calm_colors() {
  # PS1-safe sequences (wrap non-printing with \[ \])
  RESET_PS1='\[\e[0m\]'
  BOLD_PS1='\[\e[1m\]'
  CALM_BLUE_PS1='\[\e[38;2;120;170;255m\]'
  GLOW_PS1='\[\e[38;2;160;200;255m\]'

  # Raw ANSI sequences for printing to the terminal (used with printf "%b")
  RESET_RAW='\e[0m'
  BOLD_RAW='\e[1m'
  CALM_BLUE_RAW='\e[38;2;120;170;255m'
  GLOW_RAW='\e[38;2;160;200;255m'
  FG_RAW='\e[38;2;230;230;230m'
}

_short_pwd() {
  local d
  d="$PWD"
  if [ "$d" = "$HOME" ]; then
    printf "~"
  else
    printf "%s" "${d/#$HOME/~}"
  fi
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



_set_ps1() {
  _calm_colors
  local dir_sh
  dir_sh=$(_short_pwd)
  local branch
  branch=$(_git_branch)
  local git_seg=""
  if [ -n "$branch" ]; then
    git_seg=" ${GLOW_PS1}(${branch})${RESET_PS1}"
  fi
  PS1="${GLOW_PS1}${BOLD_PS1}Arch@elbulbol${RESET_PS1} ${CALM_BLUE_PS1}${dir_sh}${RESET_PS1}${git_seg}\n${GLOW_PS1}❯ ${RESET_PS1}"
}

_update_prompt() {
  _set_ps1
}

PROMPT_COMMAND=_update_prompt

# To enable automatically, add this line to your ~/.bashrc:
#   source "$HOME/.config/foot/prompt.sh"
