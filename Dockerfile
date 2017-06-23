FROM erlang:19

ENV ERLWORKDIR /opt/eflame
WORKDIR ${ERLWORKDIR}

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         iptables \
#         openssl \
#         inetutils-syslogd \
#         procps \
#         runit \
#         socat \
#         jq \
#         curl

COPY eflame_wrapper/ ${ERLWORKDIR}/

ENTRYPOINT []
CMD []