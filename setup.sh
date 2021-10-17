#!/bin/sh

set -e

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
bashrc_src="[ -f .bashrc.local ] && source .bashrc.local"

function dotconfig() {
	local config="${dir}/dots/$1"
	local dest="${HOME}/$2"
	mkdir -p $(dirname $dest)
	if [ -e "$dest" -a ! -L "$dest" ]; then
		>&2 echo "moving old config to ${dest}.old"
		mv "${dest}"{,.old}
	fi
	echo "linking $config -> $dest"
	ln -sf "$config" "$dest"
}

function bashrc_hook() {
  if ! grep -Fxq "$bashrc_src" "${HOME}/.bashrc"; then
    echo "append \"$bashrc_src\" to .bashrc"
    echo "$bashrc_src" >> ${HOME}/.bashrc
  fi
}

dotconfig init.vim .config/nvim/init.vim
dotconfig tmux.conf .tmux.conf
dotconfig bashrc .bashrc.local

bashrc_hook