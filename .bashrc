export PS1='`printf "%02X" $?`:\w `git branch 2> /dev/null | grep -e ^* | sed -E s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\$ '
