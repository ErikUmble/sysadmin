# Add 32-bit dependencies
FROM ubuntu:20.04 AS deps
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
    libc6:i386 \
    libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*


FROM pwn.red/jail
COPY --from=deps / /srv
RUN mkdir /srv/app

# challenge files
COPY ./vuln /srv/app/run
COPY ./flag /srv/app/flag

ENV JAIL_TIME 60