#!/usr/bin/env bash
# Terraria Launcher wrapper script
# Entry point of the container

# Environment Variables used within this script come from the
# container, see Dockerfile.

CONFIG="$TERRARIA_VOLUME/serverconfig.txt"

## Sanity Checks

# Refuse to run as root within the container, also indicates a lack of config
if [[ $UID -eq 0 ]] ; then
    >&2 echo "ERROR: Refusing to start as root (uid 0)."
    >&2 echo "  Verify your runtime configuration or see README."
    exit 1
fi

# Verify the uid we are running as can write to the volume
if [[ ! -w $TERRARIA_VOLUME ]] ; then
    >&2 echo "ERROR: Directory ${TERRARIA_VOLUME} is not writable."
    >&2 echo "  Did you set permissions on the host correctly?"
    >&2 echo "  Is the container configured to run as the correct user?"
    exit 1
fi

# Ensure base directories are present in volume
mkdir -p "$TERRARIA_WORLDSDIR"

## Initial Run Generation

# Configuration file, copy example if unavailable
if [[ ! -f $CONFIG ]] ; then
    cp -v "$TERRARIA_HOME/serverconfig-example.txt" "$TERRARIA_VOLUME/"

    >&2 echo " **** Initial Run ****"
    >&2 echo " ** No configuration has been found on the volume mounted"
    >&2 echo " ** under: ${TERRARIA_VOLUME}"
    >&2 echo " ** "
    >&2 echo " ** An example file has been copied to the volume as"
    >&2 echo " **   serverconfig-example.txt"
    >&2 echo " ** Review, edit and copy the configuration to"
    >&2 echo " **   serverconfig.txt"
    >&2 echo " ** and run the container again."
    >&2 echo " **"
    >&2 echo " ** You will want to configure the following paths:"
    >&2 echo " **   worldpath=${TERRARIA_WORLDSDIR}/"
    >&2 echo " **   banlist=${TERRARIA_VOLUME}/banlist.txt"
    >&2 echo " ** Your world path should be:"
    >&2 echo " **   ${TERRARIA_WORLDSDIR}/worldname.wld"
    >&2 echo " ** Where worldname is the name of your choosing."
    >&2 echo " *********************"
    exit 1
fi

# Handoff to Terraria binary
export MONO_IOMAP=all
exec ./TerrariaServer.bin.x86_64 -config $CONFIG -port $TERRARIA_PORT -noupnp
