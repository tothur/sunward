#!/usr/bin/env python3
"""Renders the Sunward app icon to PNG with no dependencies (pure Python + zlib).
A sun half-set on the horizon under a twilight sky, with its light laid down in bars on dark water."""
import math, struct, zlib, os, sys

H = 0.60          # horizon height as a fraction of the icon
R = 0.19          # sun radius
SKY = [(0, (18, 26, 84)), (.42, (58, 48, 128)), (.72, (176, 84, 128)), (.9, (242, 132, 78)), (1, (253, 176, 92))]
BARS = [(.19, .95), (.15, .8), (.11, .65), (.075, .5), (.04, .38)]   # half-width, opacity

def mix(a, b, t): return tuple(a[i] + (b[i] - a[i]) * t for i in range(3))

def pixel(u, v):
    d = math.hypot(u - .5, v - H)
    if v < H:
        t = v / H
        for (t0, c0), (t1, c1) in zip(SKY, SKY[1:]):
            if t <= t1: c = mix(c0, c1, (t - t0) / (t1 - t0)); break
        c = mix(c, (255, 214, 150), math.exp(-(d / .30) ** 2) * .5)      # soft glow
        if d < .40: c = mix(c, (255, 230, 190), .09)                      # outer halo
        if d < .30: c = mix(c, (255, 230, 190), .11)                      # inner halo
        if d < R: c = mix((255, 247, 222), (255, 206, 112), (d / R) ** 2) # the sun
        return c
    t = (v - H) / (1 - H)
    c = mix((14, 18, 52), (5, 7, 16), t)
    c = mix(c, (130, 62, 72), .38 * math.exp(-t * 9) * math.exp(-((u - .5) / .45) ** 2))
    for k, (hw, a) in enumerate(BARS):
        cy, hh = H + .055 + .062 * k, .016
        dx = max(abs(u - .5) - (hw - hh), 0)
        if math.hypot(dx, v - cy) <= hh:
            c = mix(c, mix((255, 196, 110), (240, 120, 80), k / 4), a)
    return c

def render(size, ss=3):
    rows = []
    n = ss * ss
    for y in range(size):
        row = bytearray([0])
        for x in range(size):
            r = g = b = 0
            for j in range(ss):
                for i in range(ss):
                    p = pixel((x + (i + .5) / ss) / size, (y + (j + .5) / ss) / size)
                    r += p[0]; g += p[1]; b += p[2]
            row += bytes((round(r / n), round(g / n), round(b / n)))
        rows.append(bytes(row))
    raw = b''.join(rows)
    def chunk(tag, data): return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag + data))
    return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', size, size, 8, 2, 0, 0, 0)) + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b'')

if __name__ == '__main__':
    out = sys.argv[1] if len(sys.argv) > 1 else 'icons'
    os.makedirs(out, exist_ok=True)
    for name, size in (('icon-512.png', 512), ('icon-192.png', 192), ('apple-touch-icon.png', 180)):
        open(os.path.join(out, name), 'wb').write(render(size))
        print(name, size)
