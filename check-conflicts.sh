#!/bin/bash

# Check for existing configuration files that would conflict with stow

echo "🔍 Checking for existing configuration files..."
echo ""

conflicts=0

# Check .zshrc
if [ -f ~/.zshrc ]; then
    echo "⚠️  ~/.zshrc exists"
    conflicts=1
fi

# Check .p10k.zsh
if [ -f ~/.p10k.zsh ]; then
    echo "⚠️  ~/.p10k.zsh exists"
    conflicts=1
fi

# Check nvim config
if [ -d ~/.config/nvim ]; then
    echo "⚠️  ~/.config/nvim exists"
    conflicts=1
fi

# Check wezterm config
if [ -d ~/.config/wezterm ]; then
    echo "⚠️  ~/.config/wezterm exists"
    conflicts=1
fi

echo ""

if [ $conflicts -eq 0 ]; then
    echo "✅ No conflicts found! Safe to run 'stow zsh nvim wezterm p10k'"
else
    echo "❌ Conflicts found! You need to handle these files first:"
    echo ""
    echo "Option 1 - Remove existing files:"
    echo "  rm ~/.zshrc ~/.p10k.zsh"
    echo "  rm -rf ~/.config/nvim ~/.config/wezterm"
    echo ""
    echo "Option 2 - Backup existing files:"
    echo "  stow --adopt zsh nvim wezterm p10k"
fi