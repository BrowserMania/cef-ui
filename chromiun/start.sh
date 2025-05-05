#!/bin/bash

# Lancer Xvfb (serveur virtuel X11 pour afficher Chromium sans interface graphique)
export DISPLAY=:99
Xvfb :99 -screen 0 1280x1024x24 &

# Démarrer PulseAudio pour la capture audio
pulseaudio --start

# Lancer Chromium en mode headless (sans interface graphique)
chromium --headless --no-sandbox --disable-gpu --remote-debugging-port=9222 &

# Capturer l'affichage avec ffmpeg (utiliser x11grab avec Xvfb pour le streaming vidéo)
ffmpeg -f x11grab -video_size 1280x1024 -i :99 -vcodec libx264 -acodec aac -strict experimental -f flv rtmp://localhost/live/stream &

# Démarrer BitWHIP pour diffuser via WebRTC
bitwhip --stream --server <server-whip-url> --web-rtc true &

# Maintenir le processus en vie
tail -f /dev/null
