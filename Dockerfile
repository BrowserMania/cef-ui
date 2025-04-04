#La base de l'image est une image Ubuntu 22.04
# L'image est optimisée pour exécuter une application Rust avec CEF (Chromium Embedded Framework) mais a revoir sil je trouve qu'elle est trop lourde
FROM ubuntu:22.04

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive

# Dépendances
RUN apt-get update && apt-get install -y \
    libnss3 libxcomposite1 libxcursor1 libxdamage1 libxrandr2 \
    libgtk-3-0 libxss1 libasound2 libglib2.0-0 \
    xvfb pulseaudio dbus \
    wget unzip curl ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# User non-root
RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser

# App Rust + CEF compilée
COPY --chown=appuser:appuser ./cef-client /home/appuser/cef-client

# Script d’entrée
COPY --chown=appuser:appuser ./start.sh /home/appuser/start.sh
RUN chmod +x /home/appuser/start.sh

CMD ["/home/appuser/start.sh"]
