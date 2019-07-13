# Intermediate staging container
FROM debian:10-slim AS staging

ARG VERSION="1353"
ARG SHA256="63b232323f094ea71e49ec1bb578a816b751db9f872ad70ebc1d921b8d15f250"
ARG URL="https://terraria.org/server/terraria-server-${VERSION}.zip"

# Create staging directory
RUN mkdir -p /staging

# Install required dependencies for preparation
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl ca-certificates unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /var/tmp/*

# Download, verify and extract headless server archive 
RUN curl -L $URL -o /tmp/archive_${VERSION}.zip && \
    echo "${SHA256}  /tmp/archive_${VERSION}.zip" | sha256sum -c - && \
    unzip /tmp/archive_${VERSION}.zip -d /staging && \
    rm -f /tmp/archive_${VERSION}.zip && \
    mv /staging/${VERSION}/* /staging/ && \
    rm -r /staging/${VERSION}

# Runtime image
FROM debian:10-slim

LABEL maintainer="Alexandre Gauthier <alex@lab.underwares.org>" \
    description="Terraria Server"

# These are used for runtime, you can override them if you really know
# what you are doing, but you probably shouldn't.
ENV TERRARIA_HOME /opt/terraria
ENV TERRARIA_VOLUME /data
ENV TERRARIA_PORT 7777
ENV TERRARIA_WORLDSDIR ${TERRARIA_VOLUME}/worlds

# Create runtime directories
# $HOME/.local is hardcoded for unimportant runtime data
RUN mkdir -p /opt/terraria && mkdir /data && \
    ln -sf /tmp /.local

WORKDIR /opt/terraria

# Copy default configuration
COPY --from=staging /staging/Windows/serverconfig.txt \
        serverconfig-example.txt

# Copy terraria binaries
COPY --from=staging /staging/Linux .
RUN chmod +x TerrariaServer \
    TerrariaServer.bin.x86 \
    TerrariaServer.bin.x86_64

# Copy wrapper script
COPY files/run.sh .
RUN chmod +x ./run.sh

VOLUME [${TERRARIA_VOLUME}]

EXPOSE ${TERRARIA_PORT}/tcp

ENTRYPOINT [ "/opt/terraria/run.sh" ]
