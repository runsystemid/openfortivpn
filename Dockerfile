FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y openfortivpn ppp iputils-ping && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]