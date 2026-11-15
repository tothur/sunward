# Sunward

Follow the light. A sun tracker for the web: a living sky that follows the sun, daily and yearly solar events, solstices, moon phase, and layouts for phones, foldables, tablets and laptops.

Live site: https://tothur.github.io/zenith-sun-tracker/

## Install

Sunward is a progressive web app and works offline once opened.

- **iPhone / iPad:** open the site in Safari, tap Share, then Add to Home Screen.
- **Android / Chrome / Edge:** tap the Install button in the app, or use the browser's install option.
- **Mac:** in Safari use File, Add to Dock; in Chrome or Edge use the install icon in the address bar.

## Files

- `zenith.html` is the source: one self-contained page, no dependencies apart from two web fonts.
- `index.html` is the standalone page the site serves. Regenerate it with `./build.sh` after editing `zenith.html`.
- `manifest.webmanifest` and `sw.js` make it installable and available offline.
- `icon.svg` and `icons/` are the app icon; `tools/make_icons.py` re-renders the PNGs (no dependencies).

## Run locally

```sh
./build.sh
python3 -m http.server 4173
```

Then open http://localhost:4173.

All sun and moon calculations run in the browser using standard low-precision almanac formulas. Times are typically within a minute or two; the perihelion and aphelion dates can be a day off.
