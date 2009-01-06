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
	echo "  -r	Wake up the remote client by doing a dns cache flush"
	echo "  -n	Don't start synergy in the background"
	echo "  -h	Show this screen"
	echo ""
	exit 0
}


x=1 # Avoids an error if we get no options at all.
while getopts "rnh" opt; do
  case "$opt" in
    r) REMOTE=1;;
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

if [ "$REMOTE" ]; then
#	ssh `if [ -z "$DETACH" ]; then echo '-t'; fi` synergy "screen $DETACH /Applications/QuickSynergy.app/Contents/Resources/synergyc -f -d $LEVEL Shrike.argon.lan"
	ssh synergy 'dscacheutil -flushcache'
else
	if ps -Af |grep -q [s]ynergys; then
		echo "Synergy already running, not starting again."
		exit 0
#	screen $DETACH /Applications/QuickSynergy.app/Contents/Resources/synergys -f -d $LEVEL
	elif [ "$DETACH" ]; then
		synergys -f -d $LEVEL &
	else
		synergys -f -d $LEVEL
	fi
fi
