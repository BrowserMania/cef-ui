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
# Exposer le répertoire de téléchargement
VOLUME ["/downloads"]

# Script d'initialisation
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]



# Utilisation de l'image Ubuntu 22.04
FROM ubuntu:22.04

# Mettre à jour et installer les dépendances
RUN apt-get update && apt-get install -y \
    rustc \
    cargo \
    build-essential \
    xorg \
    xvfb \
    pulseaudio \
    ffmpeg \
    gstreamer \
    libx11-dev \
    libpulse-dev \
    chromium-browser \
    git \
    curl

# Installer "just" pour faciliter le processus de construction
RUN cargo install just

# Installer les dépendances de BitWHIP
RUN curl -fsSL https://github.com/casey/just/releases/download/v0.11.0/just-v0.11.0-x86_64-unknown-linux-gnu.tar.xz | tar -xJf - -C /usr/local/bin

# Cloner le projet BitWHIP
RUN git clone https://github.com/bitwhip/bitwhip.git /bitwhip

# Se déplacer dans le dossier du projet
WORKDIR /bitwhip

# Installer les dépendances de BitWHIP et construire le projet
RUN just install-deps

# Créer un utilisateur non-root pour exécuter l'application
RUN useradd -m browserman
USER browserman

# Dossier de travail
WORKDIR /home/browserman

# Ajouter le script de démarrage
COPY start.sh /home/browserman/start.sh
RUN chmod +x /home/browserman/start.sh

# Commande de démarrage par défaut
CMD ["/home/browserman/start.sh"]
