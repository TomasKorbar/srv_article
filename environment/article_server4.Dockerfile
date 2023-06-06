FROM fedora:37

RUN dnf install -y postfix

RUN postconf -e "mynetworks = 192.168.2.0/24"
RUN postconf -e "mydestination = example-domain.com"
RUN postconf -e "maillog_file = /dev/stdout"
RUN postconf -e "inet_interfaces = all"
RUN /usr/libexec/postfix/aliasesdb

RUN useradd dummy

EXPOSE 25

CMD postfix start-fg
