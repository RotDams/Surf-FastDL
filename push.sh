#!/bin/sh

files="$(find . -type f| grep -v '.git')"
totalNbFiles=$(echo "$files" | wc -l)
nbFiles=0
currentSize=0

echo "Got $totalNbFiles files to push."

for file in $files; do

	nbFiles=$((nbFiles + 1))
	fileSize=$(du -b "$file" | cut -d'      ' -f1)
	currentSize=$((currentSize + fileSize))

	echo "-------------------(${nbFiles}/${totalNbFiles})-------------------"
	echo "Processing file: $file"
	echo "File size: $fileSize"
	echo "Current size: $currentSize"

	git add "$file"
	echo "file added."

	if [ $currentSize -gt 2000000000 ]; then
		git commit -m "files ($nbFiles) of size $currentSize"
		echo "file commited."

		ssh-agent bash -c 'ssh-add /root/.ssh/dams; git push origin master'
		echo "file added: $file"
		pushFiles=0
		currentSize=0
	fi

	git add "$file"
	echo "file added."
done

git commit -m "files ($nbFiles) of size $currentSize"
ssh-agent bash -c 'ssh-add /root/.ssh/dams; git push origin master'
echo "ended"
