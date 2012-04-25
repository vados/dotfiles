#!/bin/bash

# Bash deploy script from Johan Bleuzen
# Inspired by Rakefile from Zach Holman : https://github.com/holman/dotfiles/blob/master/Rakefile

function install {

skip_all=false
overwrite_all=false
backup_all=false

for file in `find ~/.dotfiles -name "*.symlink" | grep -v '\.git'`; do
	filename=$(basename $file)
	filename=~/.${filename%.*}

	overwrite=false
	backup=false

	if [ -e $filename ] || [ -h $filename ]; then

		if [ $skip_all == "false" ] && [ $overwrite_all == "false" ] && [ $backup_all == "false" ]; then
			echo "File already exists: $filename, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
			read ACTION

			case $ACTION in
				O) overwrite_all=true;;
				o) overwrite=true;;
				B) backup_all=true;;
				b) backup=true;;
				S) skip_all=true;;
				s) continue;;
			esac
		fi
		if [ $overwrite_all == "true" ] || [ $overwrite == "true" ]; then
			rm -rf $filename
		fi
		if [ $backup_all == "true" ] || [ $backup == "true" ]; then
			mv $filename ${filename}.backup 	
		fi
	fi
	ln -s $file $filename
done
}

function uninstall {
for file in `find ~/.dotfiles -name "*.symlink" | grep -v '\.git'`; do
	filename=$(basename $file)                                                                                                                                                   
	filename=~/.${filename%.*}
	
	if [ -h $filename ]; then
		rm -rf $filename
	fi

	if [ -e ${filename}.backup ]; then
		mv ${filename}.backup $filename
	fi
done
}

if [ "$1" == "uninstall" ]; then
	uninstall                                                                                                                                                  
	exit
fi
install