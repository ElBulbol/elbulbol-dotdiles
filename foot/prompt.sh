#!/usr/bin/env bash
# Enhanced prompt for Bash
# - shows Arch icon and username in calm blue/glow
# - prints full path (home shortened to ~) using native \w
# - shows git branch (with dirty marker)
# - Lightweight and optimized (no unnecessary forks/listings)

# Define colors once
_setup_prompt_colors() {
  RESET_PS1='\[\e[0m\]'
  BOLD_PS1='\[\e[1m\]'
  # Arch Blue for the icon
  ARCH_BLUE_PS1='\[\e[38;2;23;147;209m\]'
  # Theme colors
  CALM_BLUE_PS1='\[\e[38;2;120;170;255m\]'
  GLOW_PS1='\[\e[38;2;160;200;255m\]'
}

# Run color setup once
_setup_prompt_colors

_get_git_branch() {
  # Fast git status check
  local b
  # 2>/dev/null suppresses errors if not a git repo
  b=$(git -C "$PWD" rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  
  local dirty=""
  # Check for modifications
  if ! git -C "$PWD" diff --quiet --ignore-submodules -- 2>/dev/null || \
     ! git -C "$PWD" diff --cached --quiet --ignore-submodules -- 2>/dev/null; then
    dirty="*"
  fi
  printf " (%s%s)" "$b" "$dirty"
}

_update_ps1() {
  # Calculate git info
  local git_info
  git_info=$(_get_git_branch)
  
  # Construct the prompt
  # \w is the bash built-in for current directory (with ~)
  #  is the Arch Linux icon (Nerd Font)
  PS1="${ARCH_BLUE_PS1} ${GLOW_PS1}${BOLD_PS1}Arch@elbulbol${RESET_PS1} ${CALM_BLUE_PS1}\w${RESET_PS1}${GLOW_PS1}${git_info}${RESET_PS1}\n${GLOW_PS1}❯ ${RESET_PS1}"
}

# Set the hook
PROMPT_COMMAND=_update_ps1
