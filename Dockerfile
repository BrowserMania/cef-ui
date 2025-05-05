# Utiliser une image de base Ubuntu 22.04
FROM ubuntu:22.04

# Installation des dépendances système
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libx11-dev \
    libxtst-dev \
    libxi-dev \
    libglib2.0-dev \
    libgdk-pixbuf2.0-dev \
    libpulse-dev \
    xvfb \
    ffmpeg \
    libvpx-dev \
    libopus-dev \
    libavformat-dev \
    libavcodec-dev \
    libswscale-dev \
    libwebp-dev \
    wget \
    python3-pip \
    libssl-dev

# Installer Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"


COPY . /app/cef-ui
WORKDIR /app/cef-ui
RUN cargo build --release

# Installer BitWhip pour WebRTC
RUN git clone https://github.com/bitwhip/bitwhip
WORKDIR /app/bitwhip
RUN cargo build --release

RUN useradd -m appuser
USER appuser
push
# Exposer le répertoire de téléchargement
VOLUME ["/downloads"]

# Script d'initialisation
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
