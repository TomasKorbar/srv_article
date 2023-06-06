FROM fedora:37

RUN dnf install -y bind

RUN echo -e '$TTL  3600\n\
@  	IN SOA  example-domain.com. root.example-domain.com. (\n\
                1571655122 ; Serial number of zone file\n\
                1200       ; Refresh time\n\
                180        ; Retry time in case of problem\n\
                1209600    ; Expiry time\n\
                10800 )    ; Maximum caching time in case of failed lookups\n\
;\n\
   	IN NS   ns1.example-domain.com.\n\
   	IN A    192.168.2.0\n\
;\n\
ns1	IN A    192.168.2.2\n\
server-one           IN A   192.168.2.4\n\
server-two           IN A   192.168.2.5\n\
server-three         IN A   192.168.2.6\n\
server-four          IN A   192.168.2.7\n\
_submission._tcp     SRV 0 0 2525  server-one.example-domain.com.\n\
_submission._tcp     SRV 1 50 2625 server-two.example-domain.com.\n\
_submission._tcp     SRV 1 50 2625 server-three.example-domain.com.\n\
@ MX 0 server-four.example-domain.com.\n\
' > /etc/named/example-domain.conf.zone

RUN echo -e '\
zone "example-domain.com" IN {\n\
    type master;\n\
    allow-transfer { any; };\n\
    allow-update { any; };\n\
    file "/etc/named/example-domain.conf.zone";\n\
};\n\
' > /etc/named/example-domain.conf

RUN echo 'include "/etc/named/example-domain.conf";' >> /etc/named.conf

RUN sed -i "s/127.0.0.1/any/" /etc/named.conf
RUN sed -i "s/recursion yes/recursion no/" /etc/named.conf
RUN sed -i "s/allow-query.*//" /etc/named.conf

EXPOSE 53

CMD named -u named -g -f
