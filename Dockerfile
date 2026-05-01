FROM espressif/idf:v5.5.1

# Build a self-contained environment for MicroPython v1.27.0 native ESP32 .mpy
# module development. The ESP-IDF base image already includes the Xtensa
# toolchain and IDF Python environment; we add MicroPython plus a few host tools.

ARG DEBIAN_FRONTEND=noninteractive
ARG MICROPYTHON_VERSION=v1.27.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        git \
        make \
        pkg-config \
        python3-pyelftools \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch "${MICROPYTHON_VERSION}" --depth 1 https://github.com/micropython/micropython.git /opt/micropython \
    && git -C /opt/micropython submodule update --init --recursive

RUN make -C /opt/micropython/mpy-cross

RUN printf '\nsource /opt/esp/idf/export.sh >/dev/null 2>&1 || true\n' >> /root/.bashrc

WORKDIR /opt
