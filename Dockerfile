FROM ubuntu
MAINTAINER Chad Schmutzer <schmutze@amazon.com>

RUN apt-get -q update
RUN apt-get -y -q dist-upgrade
RUN apt-get -y -q install rsyslog python-setuptools python-pip curl
RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -o awslogs-agent-setup.py

COPY rsyslog.conf /etc/rsyslog.conf

COPY awslogs.conf awslogs.conf
RUN python ./awslogs-agent-setup.py -n -r us-east-1 -c /awslogs.conf

RUN pip install supervisor
COPY supervisord.conf /usr/local/etc/supervisord.conf

EXPOSE 514/tcp 514/udp
CMD ["/usr/local/bin/supervisord"]
