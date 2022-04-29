#!/usr/bin/env sh

function notify(){
  dunstify -a i3exit -u critical "$1";
}

LOCK="${SCREEN_LOCK_COMMAND:-i3lock -c 000000}"
case $1 in
  shutdown)
    echo "shutting down";
    notify "Shutting down, hasta luego";
    systemctl shutdown;;
  lock)
    echo "Locking down!";
    notify "Locking down!";
    $LOCK;;
  reboot)
    echo "rebooting";
    notify "Rebooting...";
    systemctl reboot;;
  suspend)
    echo "going to sleep";
    notify "Tired, gonna take a nap... Zzz";
    # i3lock -c 000000 && echo mem > /sys/power/state
    $LOCK && systemctl suspend;;
  *)
    echo "Invalid command $1";
    notify "Euh, don't know what to do with that '$1'";
    exit 1;;
esac

