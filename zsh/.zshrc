if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Basic zsh completion
autoload -U compinit && compinit

# Load autosuggestions
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Better editor integration
export VISUAL=nvim
export EDITOR=nvim
export BROWSER=open

# Aliases
alias p='cd ~/Documents/projects/'
alias s='cd ~/Documents/sandbox/'
alias ddd='rm -rf ~/Library/Developer/Xcode/DerivedData/*'
alias ls="eza --icons=always"
alias ll="eza --icons=always -l"
alias la="eza --icons=always -la"
alias sl="wezterm cli split-pane --left"
alias sb="wezterm cli split-pane --bottom"
alias nt="wezterm cli set-tab-title"
alias ca="cursor-agent text"
alias gs="git status"
alias lg="lazygit"
alias fd='fd -I'

# Utility aliases
alias lsl="ls -la"  # Show symlinks clearly
alias readlink="readlink -f"  # Show absolute path of symlink target

# Useful Functions
mkcd() { mkdir -p "$1" && cd "$1"; }
serve() { python3 -m http.server ${1:-8000}; }

# Check if something is a symlink and show target
islink() {
    if [ $# -eq 0 ]; then
        echo "Usage: islink <file_or_directory>"
        return 1
    fi
    
    for item in "$@"; do
        if [ -L "$item" ]; then
            echo "🔗 $item -> $(readlink "$item")"
        else
            echo "📄 $item (not a symlink)"
        fi
    done
}


# Initialize tools
eval "$(zoxide init zsh)" # z instead cd

# Better completion
autoload -U compinit && compinit

# Load syntax highlighting LAST to avoid conflicts
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
