#!/bin/bash

loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Do nothing if Unity license file already exists
if [[ -e "/Library/Application Support/Unity/Unity_lic.ulf" ]]; then
    echo "Unity is licensed, exiting..."
    exit 0
fi

#Launch Unity as the logged in user and license it!
echo "Licensing Unity..."
sudo -u "$loggedInUser" /Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode -serial "$4" -username "$5" -password "$6"

exit 0
