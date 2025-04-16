if status is-interactive
    # Commands to run in interactive sessions can go here
end

#alias
alias ..="cd .."
alias calc="qalc"
alias cat="bat"
alias cdh="cd /home/frvg/.config/hypr/"
alias del="gio trash"
alias ff="fastfetch"
alias lt="eza --tree --level=3 --color=always --icons=always -a"
alias ls="eza --long --color=always --icons=always -a"
alias nv="nvim"
alias pac="paru -Syu"
alias snv="sudoedit"
#alias pipes="pipes.sh -p 20 -r 0 -R -K -f 144"




#launch hyprland login on start
if uwsm check may-start
	exec uwsm start hyprland.desktop
end

#starship prompt
#starship init fish | source
#zoxide plugin
zoxide init fish | source
fzf --fish | source
fish_config theme choose "Matugen"
