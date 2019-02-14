#!/usr/bin/bash

RUBY=/home/malte/.rbenv/versions/2.5.1/bin/ruby
SCRIPT=/home/malte/Skripte/leo_search.rb
HISTORY=/home/malte/Notizen/vokabeln

# load clipboard content (for translating highlighted text)
input=`xclip -o`

# Call menu as long as exit code is 0 (esc is not pressed)
while [ "$?" -eq "0" ]; do
  # write search to history
  [[ ! -z "$input" ]] && `echo $input >> $HISTORY`
  input=`$RUBY $SCRIPT "$input" | rofi -dmenu -l 30 -p "Leo Dict: "`
done
