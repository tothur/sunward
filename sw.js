// Sunward service worker: keeps the app usable offline. All sun and moon maths runs in the page, so the shell is all it needs.
const CACHE = 'sunward-v1';
const SHELL = ['./', 'manifest.webmanifest', 'icon.svg', 'icons/icon-192.png', 'icons/icon-512.png', 'icons/apple-touch-icon.png'];

self.addEventListener('install', e => e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting())));
self.addEventListener('activate', e => e.waitUntil(
  caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim())));

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET' || !req.url.startsWith('http')) return;
  const put = res => { if (res && (res.ok || res.type === 'opaque')) { const copy = res.clone(); caches.open(CACHE).then(c => c.put(req, copy)); } return res; };
  if (req.mode === 'navigate') {
    // Pages: newest version when online, cached copy when not.
    e.respondWith(fetch(req).then(put).catch(() => caches.match(req).then(r => r || caches.match('./'))));
  } else {
    // Everything else (icons, fonts): answer from cache at once and refresh it in the background.
    e.respondWith(caches.match(req).then(hit => { const net = fetch(req).then(put).catch(() => hit); return hit || net; }));
  }
});
