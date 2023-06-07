FROM fedora:37

ARG SMTP_PORT

RUN dnf install -y postfix

RUN postconf -e "mynetworks = 192.168.2.0/24"
RUN postconf -e "maillog_file = /dev/stdout"
RUN postconf -e "inet_interfaces = all"
RUN /usr/libexec/postfix/aliasesdb

RUN sed -i "s/smtp      inet  n       -       n       -       -       smtpd/$SMTP_PORT      inet  n       -       n       -       -       smtpd/g" /etc/postfix/master.cf

CMD postfix start-fg
