#!/bin/bash

echo "Welcome to the LS command practice!"
echo "Your task is to find the hidden flag file in the '/home/user/list_command_can_find_a_lot_of_inform' directory."
echo "Use the 'ls' command with appropriate options to find the hidden file."
echo "Once you find the file, use 'cat' to read its contents."
echo "Remember, you don't have sudo privileges for this task."

script -qc /bin/bash /dev/null
