FROM alpine:3.5
MAINTAINER Daniel Eagle

ARG murmurVersion=1.2.19

# Download Murmur to /opt
ADD https://github.com/mumble-voip/mumble/releases/download/${murmurVersion}/murmur-static_x86-${murmurVersion}.tar.bz2 /opt/

# Install Murmur to /opt/murmur
RUN bzcat /opt/murmur-static_x86-${murmurVersion}.tar.bz2 | tar -x -C /opt -f - \
  && rm /opt/murmur-static_x86-${murmurVersion}.tar.bz2 \
  && mv /opt/murmur-static_x86-${murmurVersion} /opt/murmur

# User ARGs
ARG murmurUser=murmur
ARG murmurUid=1077

# Create murmur user and group
RUN addgroup -g ${murmurUid} ${murmurUser} \
  && adduser -h /opt/murmur -u ${murmurUid} -G ${murmurUser} -s /bin/sh -D ${murmurUser}

# Add Tini
RUN apk add --update tini

# Expose the appropriate ports
EXPOSE 64738/tcp 64738/udp

# Define volumes to persist data
VOLUME ["/var/murmur", "/etc/murmur"]

# Switch to murmur user
USER ${murmurUser}

ENTRYPOINT ["/sbin/tini", "--", "/opt/murmur/murmur.x86", "-fg", "-v"]

CMD ["-ini", "/etc/murmur/murmur.ini"]
