#!/usr/bin/env sh

set -e

for arg; do
	if [ -f "$arg/.no-fold" ]; then
		echo "Found .no-fold in $arg"
		while IFS= read -r dir; do
			dirpath=$HOME/$dir
			if [ -d "$HOME/$dir" ]; then
				echo "Directory ($dirpath) already exists. SKIPPING"
				continue
			fi
			echo "Creating directory $dirpath"
			mkdir -pv $HOME/$dir

		done < "$arg/.no-fold"
	fi
done

stow --ignore="\.no-fold" -t ~ $@
