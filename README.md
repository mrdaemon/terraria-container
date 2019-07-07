Terraria Container
==================

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


