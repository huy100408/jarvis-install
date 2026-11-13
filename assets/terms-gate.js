// Download gate: before any <a download> link starts a download, show the Terms of Service
// and Privacy Policy (terms.md at the site root) and require the visitor to accept them.
// Pages with <div id="termsDoc"> just render the terms (terms.html).
(function () {
  'use strict';
  var KEY = 'jarvis.termsAccepted';
  var root = new URL('../', document.currentScript.src);
  var vi = (document.documentElement.lang || '').slice(0, 2) === 'vi';
  var T = vi ? {
    eyebrow: 'TRƯỚC KHI TẢI XUỐNG', title: 'Điều khoản dịch vụ và Chính sách quyền riêng tư',
    check: 'Tôi đã đọc và đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư.',
    ok: 'Đồng ý và tải xuống', cancel: 'Hủy', fail: 'Không tải được điều khoản. Hãy thử lại.'
  } : {
    eyebrow: 'BEFORE YOU DOWNLOAD', title: 'Terms of Service and Privacy Policy',
    check: 'I have read and agree to the Terms of Service and Privacy Policy.',
    ok: 'Agree and download', cancel: 'Cancel', fail: 'Could not load the terms. Please try again.'
  };
  var store = {
    get: function () { try { return localStorage.getItem(KEY) || ''; } catch (e) { return ''; } },
    set: function (v) { try { localStorage.setItem(KEY, v); } catch (e) {} }
  };
  var terms = fetch(new URL('terms.md', root)).then(function (r) {
    if (!r.ok) throw new Error('terms ' + r.status);
    return r.text();
  }).then(function (md) {
    return { md: md, version: (/^Version:\s*(\S+)/.exec(md) || [])[1] || '' };
  });
  var loaded = null;
  terms.then(function (t) { loaded = t; }, function () {});

  // Small Markdown subset used by terms.md, built with DOM nodes only.
  function inline(parent, text) {
    text.split(/(\*\*[^*]+\*\*|https?:\/\/[^\s)]+)/).forEach(function (part) {
      if (!part) return;
      if (/^\*\*.+\*\*$/.test(part)) {
        var b = document.createElement('strong'); b.textContent = part.slice(2, -2); parent.appendChild(b);
      } else if (/^https?:\/\//.test(part)) {
        var url = part.replace(/[.,;]+$/, ''), a = document.createElement('a');
        a.href = url; a.textContent = url; a.rel = 'noopener';
        parent.appendChild(a); if (url !== part) parent.appendChild(document.createTextNode(part.slice(url.length)));
      } else parent.appendChild(document.createTextNode(part));
    });
  }
  function render(md, into) {
    var list = null;
    md.split(/\r?\n/).forEach(function (line) {
      var el;
      if (/^Version:/.test(line)) { el = document.createElement('p'); el.className = 'tg-ver'; el.textContent = line; }
      else if (/^# /.test(line)) { el = document.createElement('h2'); inline(el, line.slice(2)); }
      else if (/^## /.test(line)) { el = document.createElement('h3'); inline(el, line.slice(3)); }
      else if (/^- /.test(line)) {
        if (!list) { list = document.createElement('ul'); into.appendChild(list); }
        var li = document.createElement('li'); inline(li, line.slice(2)); list.appendChild(li); return;
      } else if (line.trim()) { el = document.createElement('p'); inline(el, line); }
      list = null;
      if (el) into.appendChild(el);
    });
  }

  var doc = document.getElementById('termsDoc');
  if (doc) {
    terms.then(function (t) { doc.textContent = ''; render(t.md, doc); }, function () { doc.textContent = T.fail; });
    return;
  }

  var css = document.createElement('style');
  css.textContent =
    '.tg{position:fixed;inset:0;margin:auto;width:min(760px,calc(100vw - 32px));height:min(88vh,860px);max-width:none;max-height:none;padding:0;' +
    'border:1px solid rgba(255,255,255,.14);border-radius:14px;background:#0a0d13;color:#e8edf3;display:flex;flex-direction:column;overflow:hidden;font-family:Geist,system-ui,sans-serif}' +
    '.tg:not([open]){display:none}.tg::backdrop{background:rgba(2,4,8,.85)}' +
    '.tg header{padding:20px 24px 12px;border-bottom:1px solid rgba(255,255,255,.08)}' +
    '.tg header p{margin:0 0 4px;font:500 11px/1.4 "Geist Mono",ui-monospace,monospace;letter-spacing:.16em;color:#7ee7ff}' +
    '.tg header h2{margin:0;font-size:20px;line-height:1.3}' +
    '.tg-body{flex:1;overflow:auto;padding:8px 24px 16px;font-size:14px;line-height:1.6;color:#c4ccd6}' +
    '.tg-body p,.tg-body li{font-size:14px;line-height:1.6;color:#c4ccd6;margin:0 0 10px}' +
    '.tg-body h2{font-size:18px;color:#fff;margin:12px 0 10px}.tg-body h3{font-size:15px;color:#fff;margin:20px 0 6px}' +
    '.tg-body a{color:#7ee7ff}.tg-body ul{padding-left:20px}.tg-ver{font:12px "Geist Mono",ui-monospace,monospace;color:#8892a0}' +
    '.tg footer{padding:14px 24px 18px;border-top:1px solid rgba(255,255,255,.08);display:flex;flex-wrap:wrap;gap:12px;align-items:center}' +
    '.tg label{flex:1 1 100%;display:flex;gap:10px;align-items:flex-start;font-size:14px;color:#e8edf3;cursor:pointer}' +
    '.tg input{width:18px;height:18px;margin-top:2px;flex:none;accent-color:#7ee7ff}' +
    '.tg button{min-height:44px;padding:0 20px;border-radius:10px;font:600 14px Geist,system-ui,sans-serif;cursor:pointer}' +
    '.tg .tg-ok{border:0;background:#fff;color:#05070b;margin-left:auto}.tg .tg-ok:disabled{opacity:.4;cursor:not-allowed}' +
    '.tg .tg-no{border:1px solid rgba(255,255,255,.2);background:transparent;color:#e8edf3}' +
    '.tg button:focus-visible,.tg input:focus-visible{outline:2px solid #7ee7ff;outline-offset:2px}';
  document.head.appendChild(css);

  function startDownload(link) {
    var a = document.createElement('a');
    a.href = link.href; a.download = link.getAttribute('download') || '';
    document.body.appendChild(a); a.click(); a.remove();
  }

  function openGate(link) {
    var dlg = document.createElement('dialog');
    dlg.className = 'tg';
    dlg.setAttribute('aria-labelledby', 'tgTitle');
    var head = document.createElement('header'), eb = document.createElement('p'), h = document.createElement('h2');
    eb.textContent = T.eyebrow; h.id = 'tgTitle'; h.textContent = T.title;
    head.append(eb, h);
    var body = document.createElement('div'); body.className = 'tg-body'; body.tabIndex = 0; body.textContent = '…';
    var foot = document.createElement('footer'), label = document.createElement('label'), check = document.createElement('input');
    check.type = 'checkbox'; label.append(check, document.createTextNode(' ' + T.check));
    var no = document.createElement('button'), ok = document.createElement('button');
    no.type = ok.type = 'button'; no.className = 'tg-no'; ok.className = 'tg-ok';
    no.textContent = T.cancel; ok.textContent = T.ok; ok.disabled = true;
    foot.append(label, no, ok);
    dlg.append(head, body, foot);
    document.body.appendChild(dlg);

    var version = '';
    function close() { if (dlg.open) dlg.close(); dlg.remove(); link.focus(); }
    check.onchange = function () { ok.disabled = !(check.checked && version); };
    no.onclick = close;
    dlg.addEventListener('cancel', function (e) { e.preventDefault(); close(); });
    ok.onclick = function () { store.set(version); close(); startDownload(link); };
    terms.then(function (t) {
      version = t.version; body.textContent = ''; render(t.md, body);
      ok.disabled = !(check.checked && version);
    }, function () { body.textContent = T.fail; });
    dlg.showModal();
    check.focus();
  }

  document.addEventListener('click', function (e) {
    var link = e.target.closest && e.target.closest('a[download]');
    if (!link || e.defaultPrevented) return;
    if (loaded && loaded.version && store.get() === loaded.version) return; // already accepted this version
    e.preventDefault();
    openGate(link);
  }, true);
})();
