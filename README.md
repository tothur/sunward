# Zenith

A sun tracker for the web: a living sky that follows the sun, daily and yearly solar events, solstices, moon phase, and layouts for phones, foldables, tablets and laptops.

Live site: https://tothur.github.io/zenith-sun-tracker/

## Files

- `zenith.html` is the source: one self-contained page, no dependencies apart from two web fonts.
- `index.html` is the standalone page the site serves. Regenerate it with `./build.sh` after editing `zenith.html`.

## Run locally

```sh
./build.sh
python3 -m http.server 4173
```

Then open http://localhost:4173.

All sun and moon calculations run in the browser using standard low-precision almanac formulas. Times are typically within a minute or two; the perihelion and aphelion dates can be a day off.
