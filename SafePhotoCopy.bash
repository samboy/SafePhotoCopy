#!/bin/bash

#BSD 2-Clause License

#Copyright (c) 2019, Sam Trenholme
#All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:

#1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.

#2. Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Usage: ./SafePhotoCopy.bash $SOURCE $DEST
## Here, SOURCE is the directory we get photos from
## DEST is the directory we put photos in
## Example:
# ./SafePhotoCopy.bash /media/SDCARD/DCIM/ /home/name/Photos/Camera/

# The place we grab photos from
SOURCE="$1"
if [ -z "$SOURCE" ] ; then
	# Probably a good idea to change this to where the card or camera
	# usually is mounted
	SOURCE=/media/SDCARD/DCIM/
fi

# The place we put photos in
DEST="$2"
if [ -z "$DEST" ] ; then
	# Probably a good idea to change this to where we put photos on the
	# local computer's hard disk
	DEST=/home/name/Photos/Camera/
fi

if [ ! -e "$SOURCE" ] ; then
	echo Can not find $SOURCE
	exit 1
fi

if [ ! -e "$DEST" ] ; then
	echo Can not find $DEST
	exit 1
fi

cd $SOURCE
for dir in * ; do
	if [ -d "$dir" ] ; then
		cd $dir
		echo entered $dir
		if [ ! -e "$DEST/$dir" ] ; then
			echo making $DEST/$dir
			mkdir $DEST/$dir
		fi
		for file in * ; do
			if [ -f "$file" ] ; then
				echo saw $file
				if [ ! -e "$DEST/$dir/$file" ] ; then
					cp "$file" "$DEST/$dir/$file"
					echo copied $file
				fi
			fi
		done
		cd ..
	fi
done

