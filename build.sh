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
<style>:root{--sat:env(safe-area-inset-top,0px);--sab:env(safe-area-inset-bottom,0px)}html{background:#070b16}html,body{height:100dvh}body>.app{position:fixed;inset:0;height:auto}.pwa{--sat:calc(env(safe-area-inset-top,0px) + 18px)}.pwa body>.app{bottom:auto;height:max(100%,100vh)}</style></head><body>
HEAD
  cat zenith.html
  cat <<'TAIL'

<script>
(()=>{ // Installed-app handling, plus a diagnostics readout (tap the daylight ring) for layout problems we cannot reproduce on a desktop
const BUILD='b6',dm=m=>matchMedia('(display-mode:'+m+')').matches,pwa=!!navigator.standalone||dm('standalone')||dm('fullscreen');
if(pwa)document.documentElement.classList.add('pwa');
const ring=document.querySelector('.ring');ring.style.pointerEvents='auto';ring.addEventListener('pointerdown',e=>e.stopPropagation());
ring.addEventListener('click',()=>{const R=Math.round,p=document.createElement('div');p.style.cssText='position:fixed;left:0;width:1px;top:env(safe-area-inset-top,0px);bottom:env(safe-area-inset-bottom,0px)';document.body.append(p);
  const r=p.getBoundingClientRect(),a=document.getElementById('app').getBoundingClientRect(),h=document.getElementById('hero').getBoundingClientRect(),v=document.createElement('div');p.remove();v.style.cssText='position:fixed;top:0;height:100vh;width:1px';document.body.append(v);const vh=v.getBoundingClientRect().height;v.remove();
  const t=[BUILD,'pwa '+pwa,'nav.standalone '+navigator.standalone,'mode '+['standalone','fullscreen','minimal-ui','browser'].filter(dm),'inner '+innerWidth+'x'+innerHeight,'client '+document.documentElement.clientHeight,'100vh '+R(vh),'vv '+(window.visualViewport?R(visualViewport.height)+' @'+R(visualViewport.offsetTop):'-'),'screen '+screen.width+'x'+screen.height,'safe top '+R(r.top)+' bottom '+R(innerHeight-r.bottom),'app '+R(a.top)+'..'+R(a.bottom),'hero '+R(h.top)+'..'+R(h.bottom),'body '+R(document.body.getBoundingClientRect().height)].join(' · ');
  const d=document.getElementById('dbg')||Object.assign(document.createElement('div'),{id:'dbg'});d.style.cssText='position:fixed;z-index:99;left:16px;right:16px;top:40%;padding:12px;border-radius:12px;background:#000c;color:#fff;font:12px/1.5 ui-monospace,monospace';d.textContent=t;d.onclick=()=>d.remove();document.body.append(d)});
})();
</script>
<script>if('serviceWorker' in navigator)addEventListener('load',()=>navigator.serviceWorker.register('sw.js').catch(()=>{}));</script>
</body></html>
TAIL
} > index.html
