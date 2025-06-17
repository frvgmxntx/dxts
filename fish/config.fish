if status is-interactive
    # Commands to run in interactive sessions can go here
end

#alias
alias ..="cd .."
alias calc="qalc"
alias cat="bat"
alias cd="z"
alias cdh="cd /home/frvg/.config/hypr/"
alias del="gio trash"
alias ff="fastfetch"
alias icat="sudo kitten icat"
alias lt="eza --tree --level=3 --color=always --icons=always -a"
alias ls="eza --long --color=always --icons=always -a"
alias nv="nvim"
alias pac="paru -Syu"
alias pyv="source ./.venv/bin/activate.fish"
alias rain="/home/frvg/.local/share/pipx/venvs/terminal-rain-lightning/bin/terminal-rain --lightning-color white"
alias snv="sudoedit"

#launch hyprland login on start
if uwsm check may-start
	exec uwsm start hyprland.desktop
end

zoxide init fish | source
fzf --fish | source
fish_config theme choose "Matugen"

# Created by `pipx` on 2025-05-15 16:06:28
set PATH $PATH /home/frvg/.local/bin
