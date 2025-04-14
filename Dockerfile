#La base de l'image est une image Ubuntu 22.04
# L'image est optimisée pour exécuter une application Rust avec CEF (Chromium Embedded Framework) mais a revoir sil je trouve qu'elle est trop lourde
FROM ubuntu:22.04

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive

# Dépendances
RUN apt-get update && apt-get install -y \
    libgtk-3-0 libglib2.0-0 libnss3 libxss1 libasound2 \
    pulseaudio x11vnc xvfb curl unzip git wget \
    libxcomposite-dev libxrandr-dev libxcursor-dev libxdamage-dev \
    libxtst-dev libx11-xcb-dev build-essential cmake pkg-config \
    libssl-dev libx11-dev libxext-dev libgl1-mesa-glx libegl1 \
    libxrender1 libxinerama1 ca-certificates \
    ffmpeg libavcodec-dev libavformat-dev libavutil-dev \
    libswscale-dev libavfilter-dev libavdevice-dev \
    clang libclang-dev llvm-dev \
    && rm -rf /var/lib/apt/lists/*



# Installer Rust et dépendances
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"


# Install Just
RUN cargo install just \
    && wget https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl-shared.tar.xz \
    && tar -xf ffmpeg-master-latest-linux64-gpl-shared.tar.xz


# ---- BUILD BitWHIP ----
WORKDIR /opt
RUN git clone https://github.com/bitwhip/bitwhip.git
WORKDIR /opt/bitwhip
RUN cd /opt/bitwhip && \
    cargo build --release

# ---- BUILD CEF-UI PROJECT ----
WORKDIR /app
COPY . /app

# Builder ton projet Rust avec CEF
RUN cargo build --release

# Script de démarrage
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
