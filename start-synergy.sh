#!/bin/bash

#defaults
DETACH="1"

showHelp () {
	echo "Usage: $0 [OPTIONS] [LOGLEVEL]"
	echo "Start up synergy locally or remotely."
	echo ""
	echo "You can optionally specify a LOGLEVEL parameter to pass to synergy[cs]."
	echo "See the synergyc or synergys help output for a list of levels."
	echo "(ERROR by default, INFO along with the -n flag is useful for debugging."
	echo ""
	echo "  -n	Don't start synergy in the background"
	echo "  -h	Show this screen"
	echo ""
	exit 0
}


x=1 # Avoids an error if we get no options at all.
while getopts "nh" opt; do
  case "$opt" in
    n) DETACH="";;
    h) showHelp;;
  esac
  x=$OPTIND
done
shift $(($x-1))

if [ -z "$1" ]; then
	LEVEL=ERROR
else
	LEVEL="$1"
fi

if ps -Af |grep -q [s]ynergys; then
	echo "Synergy already running, waking up client."
#	screen $DETACH /Applications/QuickSynergy.app/Contents/Resources/synergys -f -d $LEVEL
elif [ "$DETACH" ]; then
	synergys -f -d $LEVEL &
else
	synergys -f -d $LEVEL
fi

ssh synergy 'dscacheutil -flushcache'
