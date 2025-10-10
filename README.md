# dotfiles-macos

A lean and efficient macOS development environment configuration.

## Step 1: Install Prerequisites

First, install the required tools:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core tools
brew install neovim wezterm zoxide eza fd stow

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh plugins
brew install zsh-autosuggestions zsh-syntax-highlighting powerlevel10k
```

## Step 2: Clone and Install Dotfiles

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles-macos.git ~/.dotfiles

# Navigate to dotfiles directory
cd ~/.dotfiles

# Install all configurations
stow .

# Or install specific configurations
stow zsh p10k wezterm nvim
```

## Step 3: Restart and Configure

After installation, restart your terminal and:

- **Zsh** will load with Powerlevel10k theme and useful aliases
- **WezTerm** will use the Dracula theme with custom keybindings
- **Neovim** will start with LazyVim configuration
- Use `p10k configure` to customize your prompt

## Managing Your Dotfiles

```bash
# Install all dotfiles
stow .

# Install specific dotfiles
stow zsh nvim

# Remove all dotfiles (unlink)
stow -D .

# Remove specific dotfiles
stow -D zsh nvim

# Restow (useful after updates)
stow -R .
```

## Validation

This repository includes automated validation to ensure configuration files are valid:

```bash
# Run local validation
./validate.sh
```

