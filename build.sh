#!/bin/sh
# Wraps zenith.html (the page content) in a full document so it runs standalone: open index.html or serve this folder.
cd "$(dirname "$0")"
{ printf '<!doctype html><html lang="en"><head><meta charset="utf-8"><style>:root{padding:env(safe-area-inset-top,0px) 0 env(safe-area-inset-bottom,0px)}body{margin:0}[hidden]{display:none!important}</style></head><body>\n'; cat zenith.html; printf '\n</body></html>\n'; } > index.html
