#!/bin/bash

set -e

echo "[+] Lancement de PulseAudio..."
pulseaudio --start

echo "[+] Démarrage de Xvfb sur :99..."
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99
sleep 2

echo "[+] Lancement de l’application CEF (cef-ui-simple)..."
/app/target/release/cef-ui-simple &
CEF_PID=$!
sleep 2

echo "[+] Lancement de BitWHIP en mode streaming..."
/opt/bitwhip/target/release/bitwhip \
    stream http://localhost:1337/api/whip browsermania-token &

wait $CEF_PID
