Terraria Container
==================

[![Terraria Image CI Pipeline](https://github.com/mrdaemon/terraria-container/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/mrdaemon/terraria-container/actions/workflows/main.yml)

A hopefully reasonable Terraria server instance in a Docker Container

What is This
------------

It's an instance of the Terraria standalone server in a Docker container for
linux.

But Why?
--------

Game servers are ephemeral enough to be well suited to the purpose.
Also I have a big swarm where I can just shuffle game servers around.

What was wrong with the existing ones?
--------------------------------------

Nothing really, it's just yet another container image made by some asshole
on the internet who thought he knew better.

It runs under a host provided uid, uses an intermediate build image as to not
pollute the final image with bloated setup dependencies, and keeps all its
config and state files on a single volume, which is what I usually want
from a container image.

Can I use this?
---------------

If you want, but I can't guarantee the absence of russian backdoors, as
with every Docker image. Feel free to fork or audit this, however.

Is there tshock? Can you put it in?
-----------------------------------

Not at this time, but eventually yes. I'm still considering whether to make
hybrid images or separate variants.

Quickstart
==========

For the impatient, here is a replacement for documentation.

Quick Test
----------

1. Put your current uid in the `docker-compose.yml` file
2. Put the full path to the `testvolume` directory in the `docker-compose.yml` file
3. `$ docker-compose up --build`
4. See on screen instructions and files under the `testvolume` directory


Production
----------

1. Create a user and group to use as a service account on the docker host, note the uid and gid. It can be a system user if you'd like (ex: 999:999)
2. Create a directory tree somewhere on the host to hold the game data and configuration, e.g: `mkdir -p /srv/terraria`
3. (optional) Place your existing `serverconfig.txt` file in the root of the directory, and your `.wld` world files under `worlds/`.
4. Edit the server configuration file to match the new paths. The directory on the host is mounted under `/data`, so in the above example, an example path would be `/data/worlds/world1.wld`.
5. Change ownership and permissions on this directory tree on the host to match the service account and group you've created in step 1
6. Run the container with `--user 999:999` where the uid and gid are the ones of the service account and group, and use a volume mount for the data directory on `/data`

On first run, the container will generate an example configuration which you can edit and rename to `serverconfig.txt`.

Make sure the paths (all starting with `/data`) are correct, especially the world path and world dir.
