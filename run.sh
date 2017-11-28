#!/bin/bash
set -e
set -x

if [ ! -z "$STEAM_USERNAME" ] || [ ! -z "$STEAM_PASSWORD" ]; then
  echo "Checking for steamcmd..."
  pushd . && cd /steam
  if [ ! -e /steam/steamcmd.sh ]; then
    echo "steamcmd not found, downloading..."
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
  fi

  if [ ! -z "$STEAM_GUARDCODE" ]; then
    echo "Updating using steam guard code..."
    ./steamcmd.sh \
        +@ShutdownOnFailedCommand 1 \
        +@NoPromptForPassword 1 \
        +set_steam_guard_code $STEAM_GUARDCODE \
        +login $STEAM_USERNAME $STEAM_PASSWORD \
        +force_install_dir /starbound \
        +app_update 211820 \
        +quit
  else
    echo "Updating..."
    ./steamcmd.sh \
        +@ShutdownOnFailedCommand 1 \
        +@NoPromptForPassword 1 \
        +login $STEAM_USERNAME $STEAM_PASSWORD \
        +force_install_dir /starbound \
        +app_update 211820 \
        +quit
  fi
  popd
else
  if [ ! -e /starbound/linux/starbound_server ]; then
    echo "Starbound not installed, you must provide login credentials!"
    exit 1
  fi
  echo "No login provided, skipping update."
fi

echo "Starting server..."
cd /starbound/linux/
./starbound_server
