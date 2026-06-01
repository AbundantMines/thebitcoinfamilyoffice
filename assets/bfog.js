/* BFOG — shared interactions */
(function () {
  'use strict';

  // GA4 — runs site-wide
  if (!window.gtag) {
    var s = document.createElement('script');
    s.async = true;
    s.src = 'https://www.googletagmanager.com/gtag/js?id=G-N8PP20VBTV';
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    window.gtag = function(){ dataLayer.push(arguments); };
    gtag('js', new Date());
    gtag('config', 'G-N8PP20VBTV');
    // click + scroll-depth tracking (mirrors old site)
    document.addEventListener('click', function(e){
      var el = e.target;
      var tag = el.tagName + (el.id ? '#'+el.id : el.className ? '.'+String(el.className).trim().split(' ')[0] : '');
      gtag('event','hm_click', { page: location.pathname, el: tag.substring(0,40) });
    });
    var _sd = 0;
    window.addEventListener('scroll', function(){
      var p = Math.round(window.scrollY / (document.body.scrollHeight - window.innerHeight || 1) * 100);
      if (p >= _sd + 25) { _sd = Math.floor(p / 25) * 25; gtag('event','hm_scroll', { page: location.pathname, depth: _sd }); }
    });
  }

  // Cloudflare Web Analytics — runs site-wide
  if (!document.querySelector('script[data-cf-beacon]')) {
    var cf = document.createElement('script');
    cf.defer = true;
    cf.src = 'https://static.cloudflareinsights.com/beacon.min.js';
    cf.setAttribute('data-cf-beacon', '{"token": "3c8ee81a6842447bb64ffc1b8fb36b19"}');
    document.head.appendChild(cf);
  }

  document.documentElement.classList.remove('no-js');

  // Dropdown menu (overlay header)
  var mb = document.getElementById('menuBtn');
  var mp = document.getElementById('menuPanel');
  if (mb && mp) {
    mb.addEventListener('click', function (e) {
      e.stopPropagation();
      var open = mp.classList.toggle('open');
      mb.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    document.addEventListener('click', function (e) {
      if (mp.classList.contains('open') && !mp.contains(e.target) && !mb.contains(e.target)) {
        mp.classList.remove('open'); mb.setAttribute('aria-expanded', 'false');
      }
    });
    mp.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () { mp.classList.remove('open'); mb.setAttribute('aria-expanded','false'); });
    });
  }


  var toggle = document.querySelector('.nav-toggle');
  var links = document.querySelector('.navr');
  if (toggle && links) {
    toggle.addEventListener('click', function () {
      var open = links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    links.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () { links.classList.remove('open'); });
    });
  }

  var faders = document.querySelectorAll('.fade');
  if ('IntersectionObserver' in window && faders.length) {
    var io = new IntersectionObserver(function (es) {
      es.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
    faders.forEach(function (el) { io.observe(el); });
  } else {
    faders.forEach(function (el) { el.classList.add('in'); });
  }

  document.querySelectorAll('form[data-bfog-form]').forEach(function (form) {
    var status = form.querySelector('.status');
    form.addEventListener('submit', function (ev) {
      ev.preventDefault();
      var endpoint = form.getAttribute('action');
      var btn = form.querySelector('button[type="submit"]');
      function show(t, m) { if (!status) return; status.className = 'status ' + t; status.textContent = m; status.scrollIntoView({ behavior: 'smooth', block: 'center' }); }
      var data = Object.fromEntries(new FormData(form).entries());
      if (btn) { btn.disabled = true; btn.dataset.l = btn.textContent; btn.textContent = 'Sending…'; }
      fetch(endpoint, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) })
        .then(function (r) { if (!r.ok) throw 0; return r.json().catch(function () { return {}; }); })
        .then(function () { form.reset(); show('ok', form.getAttribute('data-success') || 'Thank you. Your submission has been received.'); })
        .catch(function () { show('err', 'Something went wrong. Please try again, or reach us another way.'); })
        .finally(function () { if (btn) { btn.disabled = false; btn.textContent = btn.dataset.l; } });
    });
  });
})();
