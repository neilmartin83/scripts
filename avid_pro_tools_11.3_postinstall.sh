#!/bin/bash
 
# This script is for Pro Tools 11.3 - it performs functions that would normally ask for admin privileges when Pro Tools is launched for the first time.
# It assumes that both Pro Tools and the iLok License Manager have already been installed.

# Let's declare a couple of variables because the author is lazy

PHT_SHOE="/Library/PrivilegedHelperTools/com.avid.bsd.shoe"
PLIST="/Library/LaunchDaemons/com.avid.bsd.shoe.plist"

# Copy the com.avid.bsd.shoe Helper Tool

/bin/cp -f "/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoe" $PHT_SHOE
/usr/sbin/chown root:wheel $PHT_SHOE
/bin/chmod 544 $PHT_SHOE
 
# Create the Launch Deamon Plist for com.avid.bsd.shoe

rm $PLIST # In case Pro Tools has been updated from a previous version
 
/usr/libexec/PlistBuddy -c "Add Label string" $PLIST
/usr/libexec/PlistBuddy -c "Set Label com.avid.bsd.shoe" $PLIST
 
/usr/libexec/PlistBuddy -c "Add MachServices dict" $PLIST
/usr/libexec/PlistBuddy -c "Add MachServices:com.avid.bsd.shoe bool" $PLIST
/usr/libexec/PlistBuddy -c "Set MachServices:com.avid.bsd.shoe true" $PLIST
 
/usr/libexec/PlistBuddy -c "Add ProgramArguments array" $PLIST
/usr/libexec/PlistBuddy -c "Add ProgramArguments:0 string" $PLIST
/usr/libexec/PlistBuddy -c "Set ProgramArguments:0 $PHT_SHOE" $PLIST
 
/bin/launchctl load $PLIST

# Create folders for AAX Plus-Ins

mkdir -p "/Library/Application Support/Avid/Audio/Plug-Ins"
mkdir -p "/Library/Application Support/Avid/Audio/Plug-Ins (Disabled)"

chmod a+w "/Library/Application Support/Avid/Audio/Plug-Ins"
chmod a+w "/Library/Application Support/Avid/Audio/Plug-Ins (Disabled)"

# Create folders for shared content

mkdir /Users/Shared/Pro\ Tools
mkdir /Users/Shared/AvidVideoEngine

chown -R root:wheel /Users/Shared/*
chmod -R a+rw /Users/Shared/*

# Done. We always succeed!

exit 0
