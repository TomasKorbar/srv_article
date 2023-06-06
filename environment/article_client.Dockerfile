FROM fedora:rawhide

RUN dnf install -y postfix bind-utils telnet

RUN postconf -e "use_srv_lookup = submission"
RUN postconf -e "relayhost = example-domain.com:submission"
RUN postconf -e "maillog_file = /dev/stdout"
RUN /usr/libexec/postfix/aliasesdb

RUN echo -e '#/bin/bash\n\
sendmail dummy@example-domain.com << EOF\n\
Subject: hello\n\
\n\
world\n\
.\n\
EOF\n\
' > senddummy.sh
RUN chmod u+x senddummy.sh

CMD postfix start-fg
