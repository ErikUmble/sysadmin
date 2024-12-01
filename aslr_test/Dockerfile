FROM pwn.red/jail
COPY --from=ubuntu:plucky-20241111 / /srv
RUN mkdir /srv/app
COPY ./vuln /srv/app/run

ENV JAIL_TIME 60
