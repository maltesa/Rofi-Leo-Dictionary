#!/usr/bin/bash

# load ruby rvm path
# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi
# rvm use default

# load clipboard content (for translating highlighted text)
input=`xclip -o`

# Call menu
if [[ -z "$input" ]]; then
  input=$( echo "" | rofi -dmenu -l 30 -p "Leo Dict: " | awk '{print $1}' )
fi

# Call search script as long as there is input
while [ -n "$input" ]; do
  input=$( ruby /home/malte/Skripte\ und\ Anwendungen/leo_search.rb $(echo $input) | rofi -dmenu -l 30 -p "Leo Dict: " | awk '{print $1}' )
done