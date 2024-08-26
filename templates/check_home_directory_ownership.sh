#!/bin/bash
##V-230322

echo "Checking home directories group ownership for local interactive users..."

# Get all local interactive users with UID >= 1000 and non-nologin shells
awk -F: '($3>=1000)&&($7 !~ /nologin/){print $1,$4,$6}' /etc/passwd | while read -r username gid homedir; do
    if [ -d "$homedir" ]; then
        # Get the group name of the primary group ID
        group_name=$(getent group "$gid" | awk -F: '{print $1}')

        # Check if the home directory is group-owned by the primary group
        dir_group=$(stat -c "%G" "$homedir")

        if [ "$group_name" != "$dir_group" ]; then
            echo "WARNING: Home directory $homedir for user $username is not group-owned by the primary group ($group_name)."
        else
            echo "OK: Home directory $homedir for user $username is correctly group-owned by the primary group ($group_name)."
        fi
    else
        echo "WARNING: Home directory $homedir for user $username does not exist."
    fi
done
