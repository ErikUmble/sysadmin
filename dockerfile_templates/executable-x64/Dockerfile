FROM pwn.red/jail
COPY --from=ubuntu:plucky-20241111 / /srv
RUN mkdir /srv/app
COPY ./vuln /srv/app/run
COPY ./flag.txt /srv/app/flag.txt

ENV JAIL_TIME 60