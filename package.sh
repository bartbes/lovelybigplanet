#!/bin/sh

for dir in $(find libs/ -type d && find maps/ -type d && find mods/ -type d && find objects/ -type d && find resources/ -type d); do
	echo $dir
done

for file in $(find -iname "*.lua" -or -iname "*.png" -or -iname "*.jpg" -or -iname "*.mp3" -or -iname "*.ogg" -or -iname "*.xm"); do
	file=`expr "$file" : "./\(.*\)"`
	echo "=-=-=-=-${file}-=-=-=-="
	cat $file
done
echo "=-=-=-=-=-=-=-=-="
