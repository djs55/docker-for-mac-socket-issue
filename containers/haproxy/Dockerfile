FROM haproxy:1.7-alpine

ENV SYSLOG_SOCKET /dev/log
ARG HAPROXY_CFG=haproxy.cfg

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
