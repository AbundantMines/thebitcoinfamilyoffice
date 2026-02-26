/**
 * BFO Chat Widget
 * Self-contained floating chat widget for thebitcoinfamilyoffice.com
 * Injects itself when the script tag is loaded.
 */
(function () {
  'use strict';

  const API = '/api/chat';
  const SESSION_KEY = 'bfo_chat_session';
  const ACCENT = '#c9a84c';
  const BG = '#111111';
  const BG_CARD = '#141414';
  const BORDER = '#1e1e1e';
  const TEXT = '#e8e0d0';
  const TEXT_SEC = '#8a8070';

  // ── State ────────────────────────────────────────────────────────────────
  let sessionId = localStorage.getItem(SESSION_KEY) || null;
  let isOpen = false;
  let isTyping = false;

  // ── CSS ──────────────────────────────────────────────────────────────────
  const style = document.createElement('style');
  style.textContent = `
    #bfo-chat-btn {
      position:fixed; bottom:24px; right:24px; z-index:9998;
      width:52px; height:52px; border-radius:50%;
      background:${ACCENT}; border:none; cursor:pointer;
      box-shadow:0 4px 20px rgba(201,168,76,.35);
      display:flex; align-items:center; justify-content:center;
      transition:transform .2s, box-shadow .2s;
    }
    #bfo-chat-btn:hover { transform:scale(1.08); box-shadow:0 6px 28px rgba(201,168,76,.5); }
    #bfo-chat-btn svg { width:24px; height:24px; fill:#0a0a0a; }
    #bfo-chat-btn .bfo-badge {
      position:absolute; top:-3px; right:-3px;
      width:16px; height:16px; border-radius:50%;
      background:#e53e3e; display:none;
      font-size:10px; color:#fff; line-height:16px; text-align:center;
    }
    #bfo-chat-box {
      position:fixed; bottom:88px; right:24px; z-index:9999;
      width:340px; max-width:calc(100vw - 32px);
      background:${BG}; border:1px solid ${BORDER};
      border-radius:8px; overflow:hidden;
      box-shadow:0 8px 40px rgba(0,0,0,.6);
      display:flex; flex-direction:column;
      transform:translateY(20px); opacity:0; pointer-events:none;
      transition:transform .25s ease, opacity .25s ease;
      font-family:'Inter', -apple-system, sans-serif;
    }
    #bfo-chat-box.open { transform:translateY(0); opacity:1; pointer-events:all; }
    #bfo-chat-header {
      background:${BG_CARD}; border-bottom:1px solid ${BORDER};
      padding:14px 16px; display:flex; align-items:center; gap:10px;
    }
    #bfo-chat-header .avatar {
      width:32px; height:32px; border-radius:50%;
      background:${ACCENT}; display:flex; align-items:center; justify-content:center;
      font-size:16px; flex-shrink:0;
    }
    #bfo-chat-header .info { flex:1; }
    #bfo-chat-header .name { font-size:.8rem; font-weight:600; color:${TEXT}; letter-spacing:.04em; }
    #bfo-chat-header .status { font-size:.68rem; color:#48bb78; margin-top:1px; }
    #bfo-chat-close {
      background:none; border:none; cursor:pointer; padding:4px;
      color:${TEXT_SEC}; font-size:18px; line-height:1; transition:color .15s;
    }
    #bfo-chat-close:hover { color:${TEXT}; }
    #bfo-chat-messages {
      height:300px; overflow-y:auto; padding:16px; display:flex;
      flex-direction:column; gap:10px;
      scrollbar-width:thin; scrollbar-color:${BORDER} transparent;
    }
    .bfo-msg { max-width:85%; display:flex; flex-direction:column; }
    .bfo-msg.user { align-self:flex-end; }
    .bfo-msg.assistant { align-self:flex-start; }
    .bfo-bubble {
      padding:9px 13px; border-radius:14px; font-size:.78rem;
      line-height:1.55; word-break:break-word;
    }
    .bfo-msg.user .bfo-bubble {
      background:${ACCENT}; color:#0a0a0a; border-bottom-right-radius:4px;
    }
    .bfo-msg.assistant .bfo-bubble {
      background:${BG_CARD}; color:${TEXT}; border:1px solid ${BORDER};
      border-bottom-left-radius:4px;
    }
    .bfo-msg-time { font-size:.62rem; color:${TEXT_SEC}; margin-top:3px; padding:0 4px; }
    .bfo-msg.user .bfo-msg-time { align-self:flex-end; }
    .bfo-typing {
      display:flex; align-items:center; gap:4px; padding:10px 14px;
      background:${BG_CARD}; border:1px solid ${BORDER};
      border-radius:14px; border-bottom-left-radius:4px; width:fit-content;
    }
    .bfo-typing span {
      width:5px; height:5px; background:${TEXT_SEC}; border-radius:50%;
      animation:bfo-bounce .9s infinite;
    }
    .bfo-typing span:nth-child(2) { animation-delay:.2s; }
    .bfo-typing span:nth-child(3) { animation-delay:.4s; }
    @keyframes bfo-bounce {
      0%,80%,100% { transform:translateY(0); opacity:.4; }
      40% { transform:translateY(-5px); opacity:1; }
    }
    #bfo-chat-footer {
      border-top:1px solid ${BORDER}; padding:12px;
      display:flex; gap:8px; background:${BG_CARD};
    }
    #bfo-chat-input {
      flex:1; background:${BG}; border:1px solid ${BORDER};
      border-radius:6px; padding:9px 12px; color:${TEXT};
      font-family:inherit; font-size:.78rem; resize:none; outline:none;
      transition:border-color .15s; line-height:1.4; max-height:80px;
    }
    #bfo-chat-input::placeholder { color:${TEXT_SEC}; }
    #bfo-chat-input:focus { border-color:rgba(201,168,76,.5); }
    #bfo-chat-send {
      background:${ACCENT}; border:none; border-radius:6px;
      width:36px; height:36px; cursor:pointer; flex-shrink:0;
      display:flex; align-items:center; justify-content:center;
      transition:opacity .15s; align-self:flex-end;
    }
    #bfo-chat-send:disabled { opacity:.4; cursor:default; }
    #bfo-chat-send svg { width:16px; height:16px; fill:#0a0a0a; }
    #bfo-chat-powered {
      text-align:center; font-size:.6rem; color:${TEXT_SEC};
      padding:6px 12px 8px; background:${BG_CARD};
    }
    #bfo-chat-powered a { color:${ACCENT}; text-decoration:none; }
    @media(max-width:400px) {
      #bfo-chat-box { right:12px; width:calc(100vw - 24px); }
      #bfo-chat-btn { right:12px; }
    }
  `;
  document.head.appendChild(style);

  // ── HTML ─────────────────────────────────────────────────────────────────
  const btn = document.createElement('button');
  btn.id = 'bfo-chat-btn';
  btn.setAttribute('aria-label', 'Chat with Hal');
  btn.innerHTML = `
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 2C6.48 2 2 6.03 2 11c0 2.68 1.22 5.09 3.17 6.76L4 22l4.69-1.56C9.74 20.79 10.85 21 12 21c5.52 0 10-4.03 10-9S17.52 2 12 2z"/>
    </svg>
    <span class="bfo-badge" id="bfo-badge"></span>
  `;

  const box = document.createElement('div');
  box.id = 'bfo-chat-box';
  box.setAttribute('role', 'dialog');
  box.setAttribute('aria-label', 'Chat with Hal');
  box.innerHTML = `
    <div id="bfo-chat-header">
      <div class="avatar">🛰️</div>
      <div class="info">
        <div class="name">Hal — BFO Assistant</div>
        <div class="status">● Online</div>
      </div>
      <button id="bfo-chat-close" aria-label="Close chat">✕</button>
    </div>
    <div id="bfo-chat-messages" role="log" aria-live="polite"></div>
    <div id="bfo-chat-footer">
      <textarea id="bfo-chat-input" placeholder="Ask about Bitcoin estate planning…" rows="1" maxlength="600"></textarea>
      <button id="bfo-chat-send" aria-label="Send" disabled>
        <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
      </button>
    </div>
    <div id="bfo-chat-powered">Powered by <a href="https://thebitcoinfamilyoffice.com" target="_blank">The Bitcoin Family Office</a> · <a href="mailto:hal@thebitcoinfamilyoffice.com">hal@thebitcoinfamilyoffice.com</a></div>
  `;

  document.body.appendChild(btn);
  document.body.appendChild(box);

  // ── References ───────────────────────────────────────────────────────────
  const messagesEl = document.getElementById('bfo-chat-messages');
  const inputEl    = document.getElementById('bfo-chat-input');
  const sendEl     = document.getElementById('bfo-chat-send');
  const closeEl    = document.getElementById('bfo-chat-close');
  const badgeEl    = document.getElementById('bfo-badge');

  // ── Helpers ──────────────────────────────────────────────────────────────
  function formatTime(ts) {
    const d = new Date(ts || Date.now());
    return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }

  function scrollBottom() {
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }

  function addMessage(role, content, ts) {
    const wrap = document.createElement('div');
    wrap.className = `bfo-msg ${role}`;
    const bubble = document.createElement('div');
    bubble.className = 'bfo-bubble';
    bubble.textContent = content;
    const time = document.createElement('div');
    time.className = 'bfo-msg-time';
    time.textContent = formatTime(ts);
    wrap.appendChild(bubble);
    wrap.appendChild(time);
    messagesEl.appendChild(wrap);
    scrollBottom();
    return wrap;
  }

  function showTyping() {
    const el = document.createElement('div');
    el.className = 'bfo-msg assistant';
    el.id = 'bfo-typing-indicator';
    el.innerHTML = `<div class="bfo-typing"><span></span><span></span><span></span></div>`;
    messagesEl.appendChild(el);
    scrollBottom();
  }

  function hideTyping() {
    const el = document.getElementById('bfo-typing-indicator');
    if (el) el.remove();
  }

  function setInputEnabled(enabled) {
    inputEl.disabled = !enabled;
    sendEl.disabled  = !enabled || !inputEl.value.trim();
  }

  // ── Welcome Message ───────────────────────────────────────────────────────
  function showWelcome() {
    if (messagesEl.children.length === 0) {
      addMessage('assistant',
        "Hi! I'm Hal, the Bitcoin Family Office assistant. I can help you understand Bitcoin estate planning, find the right tools, or answer general questions. What's on your mind?",
        Date.now()
      );
    }
  }

  // ── Send Message ──────────────────────────────────────────────────────────
  async function send() {
    const msg = inputEl.value.trim();
    if (!msg || isTyping) return;

    inputEl.value = '';
    sendEl.disabled = true;
    inputEl.style.height = '';
    isTyping = true;

    addMessage('user', msg, Date.now());
    showTyping();
    setInputEnabled(false);

    try {
      const res = await fetch(API, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          message: msg,
          sessionId: sessionId || undefined,
          page: window.location.pathname,
        }),
      });
      const data = await res.json();
      hideTyping();

      if (data.sessionId) {
        sessionId = data.sessionId;
        localStorage.setItem(SESSION_KEY, sessionId);
      }

      if (data.reply) {
        addMessage('assistant', data.reply, Date.now());
      } else if (data.message) {
        addMessage('assistant', data.message, Date.now());
      } else {
        addMessage('assistant', 'Something went wrong. Email hal@thebitcoinfamilyoffice.com for help.', Date.now());
      }
    } catch {
      hideTyping();
      addMessage('assistant', 'Connection error. Please email hal@thebitcoinfamilyoffice.com.', Date.now());
    }

    isTyping = false;
    setInputEnabled(true);
    inputEl.focus();
  }

  // ── Toggle ────────────────────────────────────────────────────────────────
  function open() {
    isOpen = true;
    box.classList.add('open');
    badgeEl.style.display = 'none';
    showWelcome();
    inputEl.focus();
    // Track open event
    try { if (window.gtag) gtag('event', 'chat_open', { event_category: 'bfo_chat', page: location.pathname }); } catch {}
  }

  function close() {
    isOpen = false;
    box.classList.remove('open');
  }

  // ── Event Listeners ───────────────────────────────────────────────────────
  btn.addEventListener('click', () => isOpen ? close() : open());
  closeEl.addEventListener('click', close);

  inputEl.addEventListener('input', () => {
    sendEl.disabled = !inputEl.value.trim() || isTyping;
    // Auto-expand
    inputEl.style.height = '';
    inputEl.style.height = Math.min(inputEl.scrollHeight, 80) + 'px';
  });

  inputEl.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      if (!sendEl.disabled) send();
    }
  });

  sendEl.addEventListener('click', send);

  // Close on outside click
  document.addEventListener('click', (e) => {
    if (isOpen && !box.contains(e.target) && e.target !== btn) close();
  });

  // Show badge after 30 seconds if not opened yet
  setTimeout(() => {
    if (!isOpen) {
      badgeEl.style.display = 'flex';
      badgeEl.textContent = '1';
    }
  }, 30000);

})();
