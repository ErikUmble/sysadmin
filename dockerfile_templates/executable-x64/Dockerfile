FROM redpwn/jail
COPY --from=ubuntu / /srv
RUN mkdir /srv/app
COPY ./vuln /srv/app/run
COPY ./flag.txt /srv/app/flag.txt

ENV JAIL_TIME 60