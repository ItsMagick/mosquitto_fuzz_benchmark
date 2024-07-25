FROM ubuntu:latest AS mosquitto
LABEL authors="charon"

# Install dependencies
RUN apt-get -y update && \
    apt-get -y install sudo \
    apt-utils \
    build-essential \
    openssl \
    clang \
    graphviz-dev \
    libcap-dev \
    libtool \
    wget \
    automake \
    autoconf \
    bison \
    tar \
    libglib2.0-dev \
    git \
    make \
    libc-ares-dev \
    libwebsockets-dev \
    libssl-dev \
    libcjson-dev\
    make\
    xsltproc

# Download and compile mosquitto
ADD --keep-git-dir=true https://github.com/ItsMagick/mosquitto_fuzz_benchmark.git /opt/mosquitto_fuzz_benchmark
# Set working directory
WORKDIR /opt/mosquitto_fuzz_benchmark
ENV CFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer" LDFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer"
ENV CC="/opt/mosquitto_fuzz_benchmark/afl-gcc make clean all"
ENV WITH_TLS=no
ENV WITH_TLS_PSK:=no
ENV WITH_STATIC_LIBRARIES=yes
ENV WITH_DOCS=no
ENV WITH_CJSON=no
ENV WITH_EPOLL:=no
# Build Mosquitto
ENTRYPOINT ["/bin/bash"]

#RUN make binary
#
#FROM scratch AS binaries
#COPY --from=mosquitto /opt/mosquitto_fuzz_benchmark/src/mosquitto mosquitto
#COPY --from=mosquitto /opt/mosquitto_fuzz_benchmark/mosquitto.conf mosquitto.conf

