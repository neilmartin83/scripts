#!/bin/sh
## postinstall

# This script is for Pro Tools 11.3 - it performs functions that would normally ask for admin privileges when Pro Tools is launched for the first time.
# It checks that Pro Tools has already been installed and will not run if it hasn't.

if [[ -d "$3/Applications/Pro Tools.app" ]]; then
	echo "Pro Tools has been installed, running post-install tasks…"
	# Let's declare a couple of variables because the author is lazy

	PHT_SHOE="$3/Library/PrivilegedHelperTools/com.avid.bsd.shoe"
	PLIST="$3/Library/LaunchDaemons/com.avid.bsd.shoe.plist"

	# Copy the com.avid.bsd.shoe Helper Tool

	/bin/cp -f "$3/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoe" $PHT_SHOE
	/usr/sbin/chown root:wheel $PHT_SHOE
	/bin/chmod 544 $PHT_SHOE
 
	# Create the Launch Deamon Plist for com.avid.bsd.shoe

	/bin/rm "$PLIST" # In case Pro Tools has been updated from a previous version
 
	/usr/libexec/PlistBuddy -c "Add Label string" $PLIST
	/usr/libexec/PlistBuddy -c "Set Label com.avid.bsd.shoe" $PLIST
	/usr/libexec/PlistBuddy -c "Add MachServices dict" $PLIST
	/usr/libexec/PlistBuddy -c "Add MachServices:com.avid.bsd.shoe bool" $PLIST
	/usr/libexec/PlistBuddy -c "Set MachServices:com.avid.bsd.shoe true" $PLIST
	/usr/libexec/PlistBuddy -c "Add ProgramArguments array" $PLIST
	/usr/libexec/PlistBuddy -c "Add ProgramArguments:0 string" $PLIST
	/usr/libexec/PlistBuddy -c "Set ProgramArguments:0 /Library/PrivilegedHelperTools/com.avid.bsd.shoe" $PLIST
	/bin/launchctl load $PLIST

	# Create folders for AAX Plus-Ins

	/bin/mkdir -p "$3/Library/Application Support/Avid/Audio/Plug-Ins"
	/bin/mkdir -p "$3/Library/Application Support/Avid/Audio/Plug-Ins (Disabled)"
	/bin/chmod a+w "$3/Library/Application Support/Avid/Audio/Plug-Ins"
	/bin/chmod a+w "$3/Library/Application Support/Avid/Audio/Plug-Ins (Disabled)"

	# Create folders for shared content

	/bin/mkdir "$3/Users/Shared/Pro Tools"
	/bin/mkdir $3/Users/Shared/AvidVideoEngine
	/usr/sbin/chown -R root:wheel "$3/Users/Shared/Pro Tools"
	/usr/sbin/chown -R root:wheel $3/Users/Shared/AvidVideoEngine
	/bin/chmod -R a+rw "$3/Users/Shared/Pro Tools"
	/bin/chmod -R a+rw $3/Users/Shared/AvidVideoEngine

	# Remove old workspace to avoid nag message if upgrading from a previous version of Pro Tools

	/bin/rm "$3/Users/Shared/Pro Tools/Workspace.wksp"

	# Done.
else
	echo "Pro Tools is not installed, will not run post-install tasks"
fi

exit 0
