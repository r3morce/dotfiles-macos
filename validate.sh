#!/bin/bash

# Dotfiles Validation Script
# Run this script to validate your dotfiles configuration

set -e

echo "🔍 Validating dotfiles configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
  if [ $1 -eq 0 ]; then
    echo -e "${GREEN}✅ $2${NC}"
  else
    echo -e "${RED}❌ $2${NC}"
    return 1
  fi
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "README.md" ] || [ ! -d ".github" ]; then
  echo -e "${RED}❌ Please run this script from the dotfiles root directory${NC}"
  exit 1
fi

echo "📁 Checking file structure..."

# Check required directories
for dir in zsh nvim wezterm p10k; do
  if [ -d "$dir" ]; then
    print_status 0 "$dir directory exists"
  else
    print_status 1 "$dir directory missing"
  fi
done

# Check key files
key_files=(
  "zsh/.zshrc"
  "nvim/.config/nvim/init.lua"
  "wezterm/.config/wezterm/wezterm.lua"
  "p10k/.p10k.zsh"
)

echo "📄 Checking key files..."
for file in "${key_files[@]}"; do
  if [ -f "$file" ]; then
    print_status 0 "$file exists"
  else
    print_status 1 "$file missing"
  fi
done

# Validate Zsh configuration
echo "🐚 Validating Zsh configuration..."
if command -v zsh >/dev/null 2>&1; then
    if zsh -n zsh/.zshrc 2>/dev/null; then
        print_status 0 "zsh/.zshrc syntax is valid"
    else
        print_status 1 "zsh/.zshrc has syntax errors"
    fi
else
    # Fallback: try to source the file with bash
    if bash -c "source zsh/.zshrc" 2>/dev/null; then
        print_status 0 "zsh/.zshrc can be sourced without errors"
    else
        print_warning "zsh/.zshrc may have issues when sourced"
    fi
fi

# Validate Lua files
echo "🔧 Validating Lua files..."
if command -v lua >/dev/null 2>&1 || command -v luajit >/dev/null 2>&1; then
  # Determine which Lua command to use
  LUA_CMD="lua"
  if ! command -v lua >/dev/null 2>&1 && command -v luajit >/dev/null 2>&1; then
    LUA_CMD="luajit"
  fi

  # Check WezTerm config (syntax only, not execution)
  if $LUA_CMD -e "loadfile('wezterm/.config/wezterm/wezterm.lua')" 2>/dev/null; then
    print_status 0 "WezTerm configuration syntax is valid"
  else
    print_status 1 "WezTerm configuration has syntax errors"
  fi

  # Check Neovim Lua files (syntax only, not execution)
  lua_errors=0
  for file in $(find nvim -name "*.lua"); do
    if ! $LUA_CMD -e "loadfile('$file')" 2>/dev/null; then
      print_warning "Lua file may have syntax issues: $file"
      lua_errors=1
    fi
  done

  if [ $lua_errors -eq 0 ]; then
    print_status 0 "All Neovim Lua files are valid"
  fi
else
  print_warning "lua not available, skipping Lua validation"
fi

# Check for Stow compatibility
echo "🔗 Checking Stow compatibility..."
stow_issues=0
for dir in zsh nvim wezterm p10k; do
  if [ -d "$dir" ]; then
    # Check if there are dotfiles at root level (which is fine for Stow)
    dot_files=$(find "$dir" -maxdepth 1 -name ".*" -type f)
    if [ -n "$dot_files" ]; then
      print_status 0 "$dir has dotfiles at root level (Stow-compatible)"
    else
      # Check if there are dotfiles in subdirectories (also fine for Stow)
      subdir_dotfiles=$(find "$dir" -name ".*" -type f)
      if [ -n "$subdir_dotfiles" ]; then
        print_status 0 "$dir has dotfiles in subdirectories (Stow-compatible)"
      else
        # For wezterm, also check for .lua files in .config subdirectories
        if [ "$dir" = "wezterm" ]; then
          config_files=$(find "$dir" -name "*.lua" -type f)
          if [ -n "$config_files" ]; then
            print_status 0 "$dir has configuration files in subdirectories (Stow-compatible)"
          else
            print_warning "$dir has no configuration files found"
            stow_issues=1
          fi
        else
          print_warning "$dir has no dotfiles found"
          stow_issues=1
        fi
      fi
    fi
  fi
done

if [ $stow_issues -eq 0 ]; then
  print_status 0 "Directory structure is Stow-compatible"
fi

# Check for common issues
echo "🔍 Checking for common issues..."

# Check for hardcoded paths (informational only)
if grep -r "/Users/" . --exclude-dir=.git --exclude-dir=.github --exclude="validate.sh" >/dev/null 2>&1; then
  print_warning "Found hardcoded user paths. Consider using \$HOME or ~ instead for better portability."
fi

echo ""
echo -e "${GREEN}🎉 Validation complete!${NC}"
echo "Run 'stow .' to install your dotfiles"

