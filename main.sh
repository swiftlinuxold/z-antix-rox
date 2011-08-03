#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit 2
fi

IS_CHROOT=0 # changed to 1 if and only if in chroot mode
USERNAME=""
DIR_DEVELOP=""

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# /srv directory only exists in chroot mode
if [-d "/srv"]; then
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
else
	USERNAME=$(logname) # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
fi

echo "CHANGING ROX"
PB_TO_COPY=$DIR_DEVELOP/rox/ROX-Filer/pb_swift-diet

echo "Replacing the pb_* file"
if [ $IS_CHROOT -eq 0 ]; then
	rm /home/$USERNAME/.config/rox.sourceforge.net/ROX-Filer/pb*
	cp $PB_TO_COPY /home/$USERNAME/.config/rox.sourceforge.net/ROX-Filer/pb_swift
	chown $USERNAME:users /home/$USERNAME/.config/rox.sourceforge.net/ROX-Filer/pb_swift
fi

rm /etc/skel/.config/rox.sourceforge.net/ROX-Filer/pb*
cp $PB_TO_COPY /etc/skel/.config/rox.sourceforge.net/ROX-Filer/pb_swift
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /etc/skel/.config/rox.sourceforge.net/ROX-Filer/pb_swift
else
	chown demo:users /etc/skel/.config/rox.sourceforge.net/ROX-Filer/pb_swift
fi

echo "Replacing pinboardtoggle.sh"
SH_TO_COPY=$DIR_DEVELOP/rox/usr_local_bin/pinboardtoggle.sh
rm /usr/local/bin/pinboardtoggle.sh
cp $DIR_DEVELOP/rox/usr_local_bin/pinboardtoggle.sh /usr/local/bin
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /usr/local/bin/pinboardtoggle.sh
else
	chown demo:users /usr/local/bin/pinboardtoggle.sh
fi

exit 0
