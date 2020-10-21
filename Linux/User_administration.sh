#! /bin/bash

# This script is to add, delete users to Linux system including password

#Check if the current user is an administrator.

if [ $(id -u) -eq 0 ]; then
        echo "Good Day Mr.$(whoami). Please choose appropriate option"
        echo "To add a new User, Type 1: " 
        echo  "To delete an existing User, Type 2: "
        read -p "Your Preference is: " admin
# Adding a new User
        if [ "$admin" == "1" ]; then
                read -p "Enter UserName: " add_u
                read -s -p "Enter Password: " add_password
                egrep $add_u /etc/passwd > /dev/null
                if [ $? -eq 0 ]; then
                       echo "$add_u already exists!"
                       exit 1
                else
                        pass=$(perl -e 'print crypt ($ARGV[0], "add_password")' $add_password)
                        useradd -m -p "$pass" "$add_u"
                [ $? -eq 0  ] && printf '%s\n' "User $add_u has been added to the system!" || echo  "Failed to add a user!"
                fi
# Deleting a User
        elif [ "$admin" == "2" ]; then
                read -p "Enter UserName: " del_username
                egrep $del_username /etc/passwd > /dev/null
                if [ $? -ne 0 ]; then
                       echo "$del_username does not exist!"
                       exit 2
                 else
                        userdel -r $del_username
                [ $? -eq 0  ] && echo "User $del_username has been removed from the system including the home directory!" || echo "Failed to add a user!"
                fi
        fi
else
        echo "You are no authorized to this action. Please contact the system administrator."
        exit 3
fi
