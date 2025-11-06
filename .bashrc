# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

# --- System Information Utility ---
fastfetch

# Set Fzf to use 'bat' for syntax highlighting previews
export FZF_DEFAULT_OPTS="--layout=reverse --info=inline --preview='bat --color=always --style=numbers --style=changes {}'"

# Set 'ls' to use the modern, icon-enhanced 'eza' command by default
alias ls='eza -l --icons --git --group-directories-first'

alias zedit='env -u WAYLAND_DISPLAY GPUI_X11_SCALE_FACTOR=1 zedit "$@"'

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Fzf Integration
# The '.sh' file is often used for both zsh and bash for compatibility
source /usr/share/fzf/key-bindings.bash

# Add this to ~/.bashrc or ~/.zshrc and then source the file
ytget() {
    # Ensure at least one argument is provided (the URL)
    if [ -z "$1" ]; then
        echo "Usage: ytget <youtube_url> [optional_filename_prefix]"
        return 1
    fi

    URL="$1"
    FILENAME_PREFIX="$2" # Optional argument for a custom name

    if [ -n "$FILENAME_PREFIX" ]; then
        # Use a custom output template if a prefix is provided
        yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" \
               --merge-output-format mp4 \
               -o "${FILENAME_PREFIX}.%(ext)s" \
               "$URL"
    else
        # Use default naming convention
        yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" \
               --merge-output-format mp4 \
               "$URL"
    fi
}
