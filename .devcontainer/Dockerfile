# Devcontainers base image (Ubuntu 20.04, includes user "vscode" with sudo)
FROM mcr.microsoft.com/devcontainers/base:ubuntu-20.04

ARG DEBIAN_FRONTEND=noninteractive

# --- Core tools, Python, etc. (run as root) ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        curl \
        build-essential \
        cmake \
        ninja-build \
        python3 \
        python3-pip \
        python3-venv \
        python-is-python3 \
        ca-certificates \
        flex \
        bison \
        gperf \
        libffi-dev \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# CMake on Ubuntu sometimes expects /usr/bin/gmake
RUN ln -sf /usr/bin/make /usr/bin/gmake

# --- Xtensa toolchain for ESP8266 ---
ENV XTENSA_TOOLCHAIN_URL="https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz"

RUN mkdir -p /opt/xtensa && \
    cd /opt/xtensa && \
    wget -q "${XTENSA_TOOLCHAIN_URL}" -O toolchain.tar.gz && \
    tar -xzf toolchain.tar.gz && \
    rm toolchain.tar.gz

ENV PATH="/opt/xtensa/xtensa-lx106-elf/bin:${PATH}"

# --- ESP8266 RTOS SDK ---
RUN mkdir -p /opt/esp && \
    cd /opt/esp && \
    git clone --recursive https://github.com/espressif/ESP8266_RTOS_SDK.git

ENV IDF_PATH="/opt/esp/ESP8266_RTOS_SDK"

# Python deps for the SDK (system-wide, visible to all users)
RUN python -m pip install --upgrade pip setuptools wheel && \
    python -m pip install --no-cache-dir -r "${IDF_PATH}/requirements.txt" && \
    if [ -f "${IDF_PATH}/tools/requirements/requirements.txt" ]; then \
        python -m pip install --no-cache-dir -r "${IDF_PATH}/tools/requirements/requirements.txt"; \
    fi && \
    python -m pip install --no-cache-dir \
        future \
        pyserial \
        pyyaml \
        pyparsing \
        kconfiglib

# Make sure the non-root user "vscode" can read/write SDK/toolchain dirs if needed
RUN chown -R vscode:vscode /opt/xtensa /opt/esp || true

# --- Final user & working dir ---
USER vscode
WORKDIR /workspaces
