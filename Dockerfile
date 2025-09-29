FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y openfortivpn && \
    rm -rf /var/lib/apt/lists/*

CMD ["openfortivpn", "-c", "/etc/openfortivpn/config"]