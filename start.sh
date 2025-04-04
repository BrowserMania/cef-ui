#!/bin/bash

# Script pour lancer Chromium Embedded Framework (CEF) en mode headless

# Lancons PulseAudio en mode "dummy"
 echo "[+] Lancement du serveur PulseAudio..."

pulseaudio -D --exit-idle-time=-1

# Lancer l’app Chromium dans CEF (en mode headless mais avec GUI actif)
echo "[+] Lancement de l'application CEF..."
xvfb-run --auto-servernum --server-num=99 --server-args="-screen 0 1280x720x24" \
    --server-args="-ac -s 0 -nolock" \   
    --auth-file=/tmp/xauth \
    -- /usr/bin/cefclient --enable-media-stream \
    --no-sandbox \
    --disable-gpu \ 
    --disable-software-rasterizer \
    --disable-dev-shm-usage \
    --disable-extensions \
    --disable-infobars \
    --disable-web-security \
    --allow-file-access-from-files \
    --allow-file-access-from-all-urls \
    --allow-http-background-page \
    --allow-insecure-localhost \
    --user-data-dir=/tmp/cef-data \
    --disable-application-cache \
./cef-client &

# Attendre que l'app se lance, puis capturer l’écran et le son
sleep 5

# ffmpeg capture X11 + Pulse et envoie vers WebRTC ou RTP
ffmpeg \
    -f x11grab -video_size 1280x720 -i :99.0 \
    -f pulse -i default \
    -vcodec libx264 -preset ultrafast -tune zerolatency \
    -acodec aac -b:a 128k \
    -f rtp rtp://YOUR_SFU_HOST:5004

