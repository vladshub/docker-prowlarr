FROM mcr.microsoft.com/dotnet/runtime:6.0-focal
ARG TARGETARCH
ARG TIMEZONE="Asia/Jerusalem"
ARG VERSION=4.0.5.5981
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=$TIMEZONE
RUN mkdir -p /var/lib/prowlarr && \
    apt update && apt install wget sqlite3 -yyq
# x64    arm     arm64
# amd64  arm/v7  arm64
RUN case $TARGETARCH in \
    amd64) echo "x64" > arch;;\
    arm) echo "arm" > arch;;\
    arm64) echo "arm64" > arch;;\
    *) echo "Failed to TARGETARCH=$TARGETARCH is not compatible with Prowlarr" && exit 2;;\
esac;

RUN export ARCH=$(cat arch); \
    wget -O Prowlarr.tar.gz "https://github.com/Prowlarr/Prowlarr/releases/download/v${VERSION}/Prowlarr.develop.${VERSION}.linux-core-${ARCH}.tar.gz"; \
    tar xzvf Prowlarr.tar.gz -C /opt; \
    rm -f Prowlarr.tar.gz arch; \
    test -f /opt/Prowlarr/Prowlarr && echo "installed successfully" || exit 1
WORKDIR /opt/Prowlarr
CMD /opt/Prowlarr/Prowlarr -nobrowser -data=/var/lib/prowlarr/

VOLUME [ "/var/lib/prowlarr" ]
EXPOSE 7878