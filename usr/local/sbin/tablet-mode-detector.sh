#!/bin/bash

set -x

SCREEN_NAME='eDP-1'
ACCEL_X_DEVICE='/sys/bus/iio/devices/iio:device0/in_accel_x_raw'
ACCEL_Y_DEVICE='/sys/bus/iio/devices/iio:device0/in_accel_y_raw'
GNOME_RANDR='/usr/local/sbin/gnome-randr.py'
GSETTINGS='/usr/bin/gsettings'
SYSTEMCTL='/usr/bin/systemctl'
SUDO='/usr/bin/sudo'
GREP='/usr/bin/grep'
CUT='/usr/bin/cut'
TR='/usr/bin/tr'

function getposition()
{
  echo "$($GNOME_RANDR --current | $GREP rotation: | $CUT -d' ' -f8 | $TR -d ,)"
}

function autorotate()
{
  X_POSITION="$(cat $ACCEL_X_DEVICE)"
  Y_POSITION="$(cat $ACCEL_Y_DEVICE)"
  CURRENT_POSITION=getposition
  if [ $Y_POSITION -lt -400 ] && [ $X_POSITION -gt -200 ] && [ $X_POSITION -lt 200 ]; then
    if [ "$CURRENT_POSITION" != "right" ]; then 
      $GNOME_RANDR --output $SCREEN_NAME --rotate right
      $GSETTINGS set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
      $GSETTINGS set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
      $SUDO $SYSTEMCTL start disable-physical-keyboard.service
    fi
  fi
  if [ $Y_POSITION -gt 400 ] && [ $X_POSITION -gt -200 ] && [ $X_POSITION -lt 200 ]; then
    if [ "$CURRENT_POSITION" != "left" ]; then 
      $GNOME_RANDR --output $SCREEN_NAME --rotate left
      $GSETTINGS set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
      $GSETTINGS set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
      $SUDO $SYSTEMCTL start disable-physical-keyboard.service
    fi
  fi
  if [ $Y_POSITION -gt -200 ] && [ $Y_POSITION -lt 200 ] && [ $X_POSITION -lt 0 ]; then
    if [ "$CURRENT_POSITION" != "normal" ]; then 
      $GNOME_RANDR --output $SCREEN_NAME --rotate normal
      $GSETTINGS set org.gnome.desktop.a11y.applications screen-keyboard-enabled false
      $GSETTINGS set org.gnome.desktop.peripherals.touchpad send-events 'enabled'
      $SUDO $SYSTEMCTL stop disable-physical-keyboard.service
    fi
  fi
  if [ $Y_POSITION -gt -200 ] && [ $Y_POSITION -lt 200 ] && [ $X_POSITION -gt 0 ]; then
    if [ "$CURRENT_POSITION" != "up" ]; then 
      $GNOME_RANDR --output $SCREEN_NAME --rotate up
      $GSETTINGS set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
      $GSETTINGS set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
      $SUDO $SYSTEMCTL start disable-physical-keyboard.service
    fi
  fi
}

while [ true ]; do
  autorotate &> /dev/null
  sleep 1
done

