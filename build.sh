#!/bin/sh
# Wraps zenith.html (the page content) in a full document with the PWA tags, so it runs standalone as index.html.
cd "$(dirname "$0")"
{ cat <<'HEAD'
<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="description" content="Sunward: a living sky that follows the sun, with today's solar events, solstices and the year of daylight.">
<meta name="theme-color" content="#0b1030">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icon.svg" type="image/svg+xml">
<link rel="icon" href="icons/icon-192.png" sizes="192x192" type="image/png">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="Sunward">
<style>:root{--sat:env(safe-area-inset-top,0px);--sab:env(safe-area-inset-bottom,0px)}html{background:#070b16}html,body{height:100dvh}body>.app{position:fixed;inset:0;height:auto}body{margin:0}[hidden]{display:none!important}</style></head><body>
HEAD
  cat zenith.html
  cat <<'TAIL'

<script>if('serviceWorker' in navigator)addEventListener('load',()=>navigator.serviceWorker.register('sw.js').catch(()=>{}));</script>
</body></html>
TAIL
} > index.html
