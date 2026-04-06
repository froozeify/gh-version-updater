#!/usr/bin/env bash
# lib/tools.sh — logging helpers and small utilities for update-version.

# Guard against double-sourcing.
[[ -n "${_UV_TOOLS_LOADED:-}" ]] && return 0
readonly _UV_TOOLS_LOADED=1

# ---------------------------------------------------------------------------
# ANSI color codes
# GitHub Actions runners render ANSI in the step log.
# ---------------------------------------------------------------------------

readonly COLOR_RESET='\033[0m'
readonly COLOR_BOLD='\033[1m'
readonly COLOR_DIM='\033[2m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_CYAN='\033[0;36m'

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------

log() {
  printf "${COLOR_CYAN}[update-version]${COLOR_RESET} %s\n" "$*"
}

# Section header
step() {
  printf "\n${COLOR_BOLD}${COLOR_CYAN}▶ %s${COLOR_RESET}\n" "$*"
}

warn() {
  printf "${COLOR_YELLOW}[update-version] WARNING:${COLOR_RESET} %s\n" "$*"
  echo "::warning::update-version: $*"
}

fail() {
  printf "${COLOR_RED}[update-version] ERROR:${COLOR_RESET} %s\n" "$*" >&2
  echo "::error::update-version: $*"
  exit 1
}

# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

# Strip a leading 'v' prefix from a version string (e.g. v1.2.3 → 1.2.3).
strip_v_prefix() {
  local raw_version="$1"
  echo "${raw_version#v}"
}

# Replace all occurrences of {version} in a template string with a real version.
render_template() {
  local template="$1"
  local version="$2"
  echo "${template//\{version\}/$version}"
}
