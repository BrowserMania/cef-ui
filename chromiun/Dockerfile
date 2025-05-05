FROM debian:bookworm-slim

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="BrowserMania version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="level sony"

# title
ENV TITLE=Chromium

# Mise à jour et installation des dépendances nécessaires
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    chromium \
    chromium-l10n \
    curl \
    ffmpeg \
    pulseaudio \
    git \
    x11vnc \
    xvfb \
    libx11-dev \
    libpulse-dev \
    ca-certificates && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Créer un lien symbolique pour chromium
RUN ln -sf /usr/bin/chromium /usr/local/bin/chromium

# Configuration de Chromium pour qu'il fonctionne en mode headless
RUN echo "**** configure chromium for headless mode ****" && \
    echo "Chromium configured for headless mode."

# Installation de Rust et Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Installer `just` avec cargo (à revoir car il y a un problème de dépendance)
RUN cargo install just

# Installer et construire BitWHIP
RUN git clone https://github.com/bitwhip/bitwhip.git /bitwhip && \
    cd /bitwhip && \
    just install-deps && \
    just build

RUN apt-get purge -y x11vnc && apt-get autoremove -y

# Ajouter les fichiers locaux (si nécessaire)
COPY /root /

# Créer un point d'exposition pour l'application (port HTTP, mais pas VNC)
EXPOSE 3000

# Créer un volume pour la configuration
VOLUME /config

# Définir le script de démarrage (headless Chromium et WebRTC)
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exécution par défaut du script de démarrage
CMD ["/start.sh"]
