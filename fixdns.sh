#!/bin/bash
echo -e "update delete shrike.argon.lan A\nupdate delete shrike.argon.lan TXT\nsend\nquit" | nsupdate -y rndc_key_dhcp:`cat ~/.rndc`
