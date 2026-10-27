#!/usr/bin/env bash
# Gera os PNGs do ícone e da tela de abertura a partir dos SVGs em assets/.
set -euo pipefail
mkdir -p assets/build
rsvg-convert -w 1024 -h 1024 assets/icon.svg -o assets/build/icon-only.png
rsvg-convert -w 1024 -h 1024 assets/icon-foreground.svg -o assets/build/icon-foreground.png
rsvg-convert -w 1024 -h 1024 assets/icon-background.svg -o assets/build/icon-background.png
rsvg-convert -w 2732 -h 2732 assets/splash.svg -o assets/build/splash.png
cp assets/build/splash.png assets/build/splash-dark.png
