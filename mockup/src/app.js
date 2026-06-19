/* ============================================================
   BI-SU Member's App Mockup — アプリロジック
   表示される会員情報・注文・距離はすべてダミー
   （商品名・価格・店舗情報・ランク制度は公式サイト掲載情報を参照）
   ============================================================ */

/* ---------- 会員ランク（公式クラブメンバーズプログラム準拠） ---------- */
const RANKS = {
  member: {
    id:'member', en:'MEMBER', jp:'一般会員', rate:1,
    color:'#C2A878', soft:'#EBDFC8',
    threshold:0, next:'silver',
    sceneA:'aerial', sceneB:'island',
    video:'assets/journey-member.mp4',   /* AI生成動画による起動演出（デモ） */
    videoEnd:3.05,                       /* ボルネオ島の全景俯瞰で着地（後半の山カットはyuka指示 2026-06-11） */
    place:'BORNEO ISLAND — ボルネオ島上空',
    annual:138400
  },
  silver: {
    id:'silver', en:'SILVER', jp:'シルバーステータス', rate:2,
    color:'#97A4AF', soft:'#DCE3E8',
    threshold:300000, next:'gold',
    sceneA:'island', sceneB:'jungle',
    video:'assets/journey-silver.mp4',   /* AI生成動画（島→ジャングル・4秒・全編使用） */
    place:'RAINFOREST — 熱帯雨林の奥へ',
    annual:386200
  },
  gold: {
    id:'gold', en:'GOLD', jp:'ゴールドステータス', rate:3,
    color:'#C3A050', soft:'#EBD9A8',
    threshold:500000, next:'platinum',
    sceneA:'jungle', sceneB:'cavemouth',
    video:'assets/journey-gold.mp4',   /* AI生成動画（ジャングル→洞窟入口） */
    videoEnd:2.8,                        /* 末尾の暗転前で着地。ホーム背景の取りこぼし防止（yuka調整 2026-06-13） */
    place:'CAVE GATE — 洞窟の入り口',
    annual:712800
  },
  platinum: {
    id:'platinum', en:'PLATINUM', jp:'プラチナステータス', rate:5,
    color:'#4E94B0', soft:'#C2E0EC',
    threshold:1000000, next:'diamond',
    sceneA:'cavemouth', sceneB:'cave',
    video:'assets/journey-platinum.mp4',   /* AI生成動画（10s）。最後の4sだけ使用 */
    videoStart:6,                          /* 6s〜（最後の4s）から再生。冒頭は見せない */
    place:'INSIDE THE CAVE — アナツバメの聖域',
    annual:1386000
  },
  diamond: {
    id:'diamond', en:'DIAMOND', jp:'ダイヤモンドステータス', rate:10,
    color:'#B23B52', soft:'#EFC2CC',
    threshold:2000000, next:null,
    sceneA:'cave', sceneB:'nest',
    video:'assets/journey-diamond.mp4',
    place:'THE NEST — 神秘の巣',
    annual:2468000
  }
};
const RANK_ORDER = ['member','silver','gold','platinum','diamond'];

const MEMBER = {
  name:'長谷部 由香',
  initials:'YH',
  no:'BS-00124857',
  mail:'y.hasebe@example.com',
  since:'2023年4月'
};

/* ---------- 定期情報（ダミー） ---------- */
const SUBSCRIPTIONS = [
  { name:'BI-SUエキスゼリースティック', img:'assets/p_jelly.jpg',
    status:'active', next:'2026/06/24（水）', cycle:'30日ごと', qty:1, price:16200 },
  { name:'BI-SUサプリメント W-500', img:'assets/p_w500.jpg',
    status:'active', next:'2026/07/02（木）', cycle:'30日ごと', qty:1, price:35640 },
  { name:'BI-SU酵素スティック', img:'assets/p_enzyme.jpg',
    status:'cancelled', last:'2026/03/15', cycle:'30日ごと', qty:1, price:17820 }
];

/* ---------- 購入履歴（ダミー） ---------- */
const ORDERS = [
  { date:'2026/06/02', no:'BS-260602-0412', ch:'ネット注文', kind:'定期購入',
    name:'BI-SUエキスゼリースティック', img:'assets/p_jelly.jpg', qty:1, price:16200 },
  { date:'2026/05/28', no:'BS-260528-1187', ch:'店頭購入', chSub:'BI-SU GINZA SIX', kind:'通常購入',
    name:'BI-SUフェイスクリーム フローラル 40g', img:'assets/p_facecream.jpg', qty:1, price:25300 },
  { date:'2026/05/19', no:'BS-260519-0233', ch:'ネット注文', kind:'通常購入',
    name:'BI-SUキャンディー（30個入り）', img:'assets/p_candy.jpg', qty:2, price:8100 },
  { date:'2026/05/03', no:'BS-260503-0871', ch:'ネット注文', kind:'定期購入',
    name:'BI-SUサプリメント W-500', img:'assets/p_w500.jpg', qty:1, price:35640 },
  { date:'2026/04/26', no:'BS-260426-0099', ch:'店頭購入', chSub:'美巣 京都祇園店', kind:'通常購入',
    name:'BI-SUシャンプー', img:'assets/p_shampoo.jpg', qty:1, price:7700 },
  { date:'2026/04/11', no:'BS-260411-0510', ch:'ネット注文', kind:'通常購入',
    name:'BI-SUフェイスマスク Type-R（4枚入り）', img:'assets/p_mask.jpg', qty:1, price:6600 },
  { date:'2026/03/30', no:'BS-260330-0786', ch:'ネット注文', kind:'定期購入',
    name:'BI-SUエキスドリンク E-3000', img:'assets/p_e3000.jpg', qty:1, price:13500 }
];

/* ---------- ストアーズ（公式サイト掲載店舗） ---------- */
const STORES = [
  { id:'gsix', name:'BI-SU GINZA SIX', en:'GINZA SIX — TOKYO', type:'直営店',
    img:'assets/s_gsix.jpg', imgClass:'obj-left', dist:'1.8km', city:'tokyo',
    addr:'東京都中央区銀座6-10-1 GINZA SIX B1F',
    hours:'10:30〜20:30', closed:'元日および施設休館日', tel:'03-6824-4117',
    access:['東京メトロ「銀座駅」A3出口より徒歩2分', '東急プラザ銀座方面 地下通路からもアクセス可'],
    desc:'ボルネオの洞窟が持つ生命の神秘を、銀座の地へ。無垢な光を放つ「巣」のオブジェが彩る空間で、インナーケアのテイスティングと、スキンケアの全ラインをお試しいただけます。',
    plan:'gsix', planNote:'GINZA SIX B1F・北側エスカレーター付近（簡略図）' },
  { id:'salone', name:'BI-SU ISETAN SALONE', en:'TOKYO MIDTOWN', type:'直営店',
    img:'assets/s_salone.jpg', dist:'4.2km', city:'tokyo',
    addr:'東京都港区赤坂9-7-4 東京ミッドタウン ガレリア2F',
    hours:'11:00〜20:00', closed:'施設休館日に準ずる', tel:'03-4400-3827',
    access:['都営大江戸線「六本木駅」8番出口より直結', '東京メトロ日比谷線「六本木駅」より地下通路直結'],
    desc:'ツバメの巣のコンシェルジュ拠点。おひとりおひとりの美しさと向き合い、最適なケアをご提案するプレミアムなサロン体験をご用意しています。',
    plan:'salone', planNote:'東京ミッドタウン ガレリア2F（簡略図）' },
  { id:'isetan', name:'イセタン ビューティー アポセカリー', en:'ISETAN SHINJUKU', type:'取扱店',
    img:'assets/s_isetan.jpg', dist:'6.1km', city:'tokyo',
    addr:'東京都新宿区新宿3-14-1 伊勢丹新宿店 本館B2F',
    hours:'10:00〜20:00', closed:'伊勢丹新宿店に準ずる', tel:null,
    access:['東京メトロ「新宿三丁目駅」直結'],
    desc:'伊勢丹新宿店 本館B2F「ビューティーアポセカリー」内の常設ショップ。百貨店のお買い物とあわせて、BI-SUのアイテムをお手に取りいただけます。',
    plan:'isetan', planNote:'伊勢丹新宿店 本館B2F（簡略図）' },
  { id:'gion', name:'美巣 京都祇園店', en:'KYOTO GION', type:'直営店',
    img:'assets/s_gion.jpg', dist:'368km', city:'kyoto',
    addr:'京都府京都市東山区祇園町南側570-118',
    hours:'11:00〜19:00', closed:'水曜日', tel:null,
    access:['京阪本線「祇園四条駅」より徒歩5分', '阪急京都線「京都河原町駅」より徒歩8分'],
    desc:'京都・祇園の町家に佇む路面店。のれんをくぐると、自然の神秘である天然アナツバメの巣の世界を、五感で体験いただけます。',
    plan:'gion', planNote:'祇園町南側・花見小路通近く（簡略図）' },
  { id:'popup', name:'ジェイアール京都伊勢丹 POP UP', en:'KYOTO STATION', type:'期間限定',
    img:null, dist:'366km', city:'kyoto',
    addr:'京都府京都市下京区烏丸通塩小路下ル東塩小路町',
    hours:'10:00〜20:00', closed:'期間中無休', tel:null,
    period:'2026.6.17（水）〜 6.23（火）',
    access:['JR「京都駅」直結'],
    desc:'ジェイアール京都伊勢丹にて、期間限定のポップアップショップを開催します。この機会にぜひお立ち寄りください。',
    plan:null }
];

/* ============================================================ */
const $ = function(sel){ return document.querySelector(sel); };
const yen = function(n){ return '¥' + n.toLocaleString('ja-JP'); };
/* 起動デフォルト=member（動画演出のデモを最初に見せるため。yuka確認 2026-06-11） */
const state = { rank:'member', screen:'home', storesView:'list', timers:[], skipFn:null, videoEl:null, splashSeq:0, obPage:0 };

/* 古い演出動画を確実に停止（DOMから外れても再生とイベント発火が続くため） */
function stopSplashVideo(){
  const v = state.videoEl;
  if (!v) return;
  try { v.pause(); v.removeAttribute('src'); v.load(); } catch (e) {}
  state.videoEl = null;
}

function rank(){ return RANKS[state.rank]; }

/* ---------- タブバー ---------- */
const TABS = [
  { id:'home', label:'ホーム',
    icon:'<svg viewBox="0 0 24 24"><path d="M3.5 10.5 12 3.5l8.5 7"/><path d="M5.5 9.5V20h13V9.5"/><path d="M10 20v-5.5h4V20"/></svg>' },
  { id:'sub', label:'定期情報',
    icon:'<svg viewBox="0 0 24 24"><path d="M20.5 12a8.5 8.5 0 1 1-2.4-5.9"/><path d="M20.5 3.5v4h-4"/><path d="M12 8v4.2l3 1.8"/></svg>' },
  { id:'history', label:'購入履歴',
    icon:'<svg viewBox="0 0 24 24"><path d="M5 3.5h14V21l-2.4-1.5L14 21l-2-1.3L10 21l-2.6-1.5L5 21Z"/><path d="M8.5 8h7M8.5 12h7M8.5 16h4"/></svg>' },
  { id:'stores', label:'ストアーズ',
    icon:'<svg viewBox="0 0 24 24"><path d="M12 21.5s-7-5.6-7-11.3A7 7 0 0 1 19 10.2c0 5.7-7 11.3-7 11.3Z"/><circle cx="12" cy="10" r="2.6"/></svg>' },
  { id:'settings', label:'設定',
    icon:'<svg viewBox="0 0 24 24"><path d="M4 7h9M17.5 7H20"/><circle cx="15" cy="7" r="2.2"/><path d="M4 17h3M11.5 17H20"/><circle cx="9" cy="17" r="2.2"/></svg>' }
];

function buildTabbar(){
  $('#tabbar').innerHTML = TABS.map(function(t){
    return '<button type="button" class="tab" data-go="' + t.id + '">' + t.icon + '<span>' + t.label + '</span></button>';
  }).join('');
  $('#tabbar').addEventListener('click', function(e){
    const b = e.target.closest('[data-go]');
    if (b) go(b.dataset.go);
  });
}

function go(id){
  state.screen = id;
  closeStoreDetail(true);
  document.querySelectorAll('.screen').forEach(function(s){ s.classList.remove('is-active'); });
  $('#screen-' + id).classList.add('is-active');
  document.querySelectorAll('.tab').forEach(function(t){
    t.classList.toggle('is-on', t.dataset.go === id);
  });
  document.body.dataset.screen = id;
  document.body.dataset.sb = (id === 'home') ? 'light' : 'dark';
  /* 3Dエンブレムはホーム表示中だけ描画（負荷対策） */
  if (window.LOGO3D && state.logo3d === 'on'){
    if (id === 'home' && $('#splash').classList.contains('is-hidden')) LOGO3D.start();
    else if (id !== 'home') LOGO3D.stop();
  }
}

/* ---------- ランク適用 ---------- */
function setRank(id, replay){
  state.rank = id;
  const r = rank();
  document.documentElement.style.setProperty('--rank', r.color);
  document.documentElement.style.setProperty('--rank-soft', r.soft);
  renderHome();
  renderSettings();
  renderRankDock();
  if (replay) playSplash();
}

/* ---------- 起動演出 ---------- */
function clearTimers(){
  state.timers.forEach(clearTimeout);
  state.timers = [];
}
function at(ms, fn){ state.timers.push(setTimeout(fn, ms)); }

function mkShot(key){
  const sc = SCENES[key];
  const d = document.createElement('div');
  d.className = 'shot';
  d.innerHTML = sc.svg;
  d.style.transformOrigin = (sc.focus[0] / 390 * 100) + '% ' + (sc.focus[1] / 844 * 100) + '%';
  d.style.willChange = 'transform, opacity';
  return d;
}

function playSplash(){
  const r = rank();
  if (r.video){ playVideoSplash(r); return; }
  state.splashSeq++;          /* 旧演出のイベントを無効化する世代番号 */
  stopSplashVideo();
  state.skipFn = finishSplash;
  const splash = $('#splash');
  const shots = $('#splash-shots');
  clearTimers();
  setHomeBg();          /* 演出の着地点＝ホーム背景 */
  go('home');

  splash.classList.remove('is-hidden', 'is-leaving');
  document.body.dataset.sb = 'light';
  shots.innerHTML = '';

  const A = mkShot(r.sceneA);
  const B = mkShot(r.sceneB);
  B.style.opacity = '0';
  shots.appendChild(A);
  shots.appendChild(B);

  /* テキスト類リセット */
  $('#splash-swallow').innerHTML = swallowSVG(r.soft);
  $('#splash-rank-en').textContent = r.en;
  $('#splash-rank-jp').textContent = r.jp;
  $('#splash-place').textContent = r.place;
  ['#splash-logo','.splash-logo'].forEach(function(){});
  const fadeEls = ['.splash-logo','#splash-swallow','#splash-rank-en','#splash-rank-jp','#splash-place'];
  fadeEls.forEach(function(s){ const el = $(s); el.style.opacity = '0'; el.style.transform = 'translateY(10px)'; el.style.transition = 'none'; });
  $('#splash-skip').classList.remove('is-shown');

  const slow = !(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  const D = slow ? 1 : 0.45;

  /* shot A: 押し込みズーム */
  A.animate(
    [ { transform:'scale(1.05)' }, { transform:'scale(2.6)' } ],
    { duration:2200 * D, easing:'cubic-bezier(.6,.04,.86,.4)', fill:'forwards' }
  );
  A.animate(
    [ { opacity:1 }, { opacity:1, offset:.66 }, { opacity:0 } ],
    { duration:2300 * D, easing:'linear', fill:'forwards' }
  );
  /* shot B: 奥から現れて定着 */
  at(1350 * D, function(){
    B.animate(
      [ { opacity:0 }, { opacity:1 } ],
      { duration:700 * D, easing:'ease-out', fill:'forwards' }
    );
    B.animate(
      [ { transform:'scale(.56)' }, { transform:'scale(1)' } ],
      { duration:2500 * D, easing:'cubic-bezier(.16,.62,.2,1)', fill:'forwards' }
    );
  });

  function reveal(sel, delay, dur){
    at(delay * D, function(){
      const el = $(sel);
      el.style.transition = 'opacity ' + (dur || 700) + 'ms ease, transform ' + (dur || 700) + 'ms cubic-bezier(.2,.7,.25,1)';
      el.style.opacity = '1';
      el.style.transform = 'none';
    });
  }
  reveal('.splash-logo', 400, 900);
  reveal('#splash-swallow', 2350);
  reveal('#splash-rank-en', 2550, 850);
  reveal('#splash-rank-jp', 2800);
  reveal('#splash-place', 3000);
  at(600 * D, function(){ $('#splash-skip').classList.add('is-shown'); });

  at(4600 * D, finishSplash);
}

/* 動画による起動演出（動画の最終フレームを撮ってホーム背景に引き継ぐ） */
function playVideoSplash(r){
  const seq = ++state.splashSeq;   /* この演出の世代。古い動画イベントはseq不一致で無視される */
  stopSplashVideo();
  const splash = $('#splash');
  const shots = $('#splash-shots');
  clearTimers();
  go('home');
  splash.classList.remove('is-hidden', 'is-leaving');
  document.body.dataset.sb = 'light';
  shots.innerHTML = '';

  const startAt = r.videoStart || 0;   /* 動画の開始位置（「最後のN秒だけ使う」場合のオフセット） */
  const v = document.createElement('video');
  v.src = r.video;
  v.muted = true;
  v.playsInline = true;
  v.setAttribute('playsinline', '');
  v.preload = 'auto';
  v.className = 'splash-video';
  if (startAt > 0){
    /* 指定位置までシークし、それまで（動画冒頭）は見せない */
    v.style.visibility = 'hidden';
    const revealVideo = function(){ v.style.visibility = ''; };
    v.addEventListener('loadedmetadata', function(){ try { v.currentTime = startAt; } catch (e) { revealVideo(); } }, { once: true });
    v.addEventListener('seeked', function once(){ v.removeEventListener('seeked', once); revealVideo(); }, { once: true });
  }
  shots.appendChild(v);
  state.videoEl = v;

  $('#splash-swallow').innerHTML = swallowSVG(r.soft);
  $('#splash-rank-en').textContent = r.en;
  $('#splash-rank-jp').textContent = r.jp;
  $('#splash-place').textContent = r.place;
  const fadeEls = ['.splash-logo','#splash-swallow','#splash-rank-en','#splash-rank-jp','#splash-place'];
  fadeEls.forEach(function(s){ const el = $(s); el.style.opacity = '0'; el.style.transform = 'translateY(10px)'; el.style.transition = 'none'; });
  $('#splash-skip').classList.remove('is-shown');

  function reveal(sel, delay, dur){
    at(delay, function(){
      const el = $(sel);
      el.style.transition = 'opacity ' + (dur || 700) + 'ms ease, transform ' + (dur || 700) + 'ms cubic-bezier(.2,.7,.25,1)';
      el.style.opacity = '1';
      el.style.transform = 'none';
    });
  }
  reveal('.splash-logo', 500, 900);
  at(700, function(){ $('#splash-skip').classList.add('is-shown'); });

  let landed = false;
  function landing(){
    if (landed || seq !== state.splashSeq) return;  /* 古い演出からの着地イベントは無視 */
    landed = true;
    v.pause();
    window.__videoHomeShot = null;
    try {
      /* フレームが実際に描画されている時だけキャプチャ（黒画像の保存を防ぐ） */
      if (v.readyState >= 2 && v.currentTime > 0.5 && v.isConnected){
        const c = document.createElement('canvas');
        c.width = v.videoWidth || 720;
        c.height = v.videoHeight || 1280;
        c.getContext('2d').drawImage(v, 0, 0);
        const shot = c.toDataURL('image/jpeg', .86);
        if (shot.length > 20000) window.__videoHomeShot = shot;
      }
    } catch (e) {
      window.__videoHomeShot = null;  /* 取得できない環境ではSVG背景のまま */
    }
    setHomeBg();
    reveal('#splash-swallow', 200);
    reveal('#splash-rank-en', 400, 850);
    reveal('#splash-rank-jp', 650);
    reveal('#splash-place', 850);
    at(2400, finishSplash);
  }
  const endAt = r.videoEnd || null;  /* 指定秒で演出を終える（動画後半のカット用） */
  /* timeupdateは発火間隔が粗く(~250ms)着地秒数が最大0.25sずれるため、rAFで毎フレーム判定して精度を上げる */
  function checkEnd(){
    if (landed) return;
    const limit = endAt || (v.duration ? v.duration - 0.12 : Infinity);
    if (v.currentTime >= limit){ landing(); return; }
    requestAnimationFrame(checkEnd);
  }
  requestAnimationFrame(checkEnd);
  v.addEventListener('ended', landing);
  v.addEventListener('error', landing);
  state.skipFn = function(){
    if (landed){ finishSplash(); return; }
    /* スキップ時も着地フレームまで送ってからキャプチャ（中途半端な絵をホーム背景にしない） */
    try {
      const target = endAt || (v.duration ? v.duration - 0.15 : 0);
      if (v.duration && Math.abs(v.currentTime - target) > 0.2){
        v.pause();
        v.addEventListener('seeked', function once(){
          v.removeEventListener('seeked', once);
          landing(); finishSplash();
        });
        v.currentTime = target;
        at(700, function(){ if (!landed) landing(); finishSplash(); });  /* seeked保険 */
        return;
      }
    } catch (e) {}
    landing(); finishSplash();
  };
  /* play()は環境により一時的に失敗することがあるためリトライ。それでも駄目なら従来演出へ着地 */
  let playTries = 0;
  function tryPlay(){
    v.play().catch(function(){
      playTries++;
      if (playTries <= 3){ at(320 * playTries, tryPlay); }
      else { landing(); }
    });
  }
  tryPlay();
}

function finishSplash(){
  clearTimers();
  stopSplashVideo();
  const splash = $('#splash');
  splash.classList.add('is-leaving');
  /* at()で登録: 直後に次の演出が始まったらclearTimers()でキャンセルされ、
     新しい演出レイヤーを誤って消さない */
  at(700, function(){
    splash.classList.add('is-hidden');
    $('#splash-shots').innerHTML = '';
    if (window.LOGO3D && state.logo3d === 'on' && state.screen === 'home') LOGO3D.start();
  });
}

/* ---------- ホーム ---------- */
function setHomeBg(){
  const r = rank();
  const bg = $('#home-bg');
  if (r.video && window.__videoHomeShot){
    bg.innerHTML = '<img class="home-bg-photo scene-live" src="' + window.__videoHomeShot + '" alt="">';
    bg.querySelector('img').style.transformOrigin = '50% 42%';
    return;
  }
  bg.innerHTML = SCENES[r.sceneB].svg;
  const svg = bg.querySelector('svg');
  svg.classList.add('scene-live');
  const f = SCENES[r.sceneB].focus;
  svg.style.transformOrigin = (f[0] / 390 * 100) + '% ' + (f[1] / 844 * 100) + '%';
}

function renderHome(){
  const r = rank();
  setHomeBg();
  /* エンブレム: 3D（Three.js）優先、不可ならフラットSVG */
  const heroEl = $('#home-swallow');
  if (!state.logo3d){
    heroEl.classList.add('is-3d');  /* 先にサイズを確保してからinit（canvas寸法が決まるため） */
    state.logo3d = (window.LOGO3D && LOGO3D.init(heroEl)) ? 'on' : 'off';
    if (state.logo3d === 'off') heroEl.classList.remove('is-3d');
  }
  if (state.logo3d === 'on'){
    LOGO3D.setColor(r.color, r.soft);
  } else {
    heroEl.innerHTML = swallowSVG(r.soft);
  }
  $('#home-rank-en').textContent = r.en;
  $('#home-rank-jp').textContent = r.jp;
  $('#home-place').textContent = r.place;
  $('#home-name').innerHTML = MEMBER.name + ' <small>様</small>';

  const points = Math.round(r.annual / 100 * r.rate);
  let progressHTML =
    '<div class="gp-row"><span class="gp-label">年間ご購入金額</span>' +
    '<span class="gp-value">' + yen(r.annual) + '</span></div>';
  if (r.next){
    const nx = RANKS[r.next];
    const span = nx.threshold - r.threshold;
    const pct = Math.min(100, Math.max(4, Math.round((r.annual - r.threshold) / span * 100)));
    progressHTML +=
      '<div class="gp-bar"><i style="width:' + pct + '%"></i></div>' +
      '<p class="gp-next">' + nx.en + ' まであと <b>' + yen(nx.threshold - r.annual) + '</b></p>';
  } else {
    progressHTML +=
      '<div class="gp-bar"><i style="width:100%"></i></div>' +
      '<p class="gp-next">最上位ステータスのお客様です。いつもありがとうございます。</p>';
  }
  $('#home-progress').innerHTML = progressHTML;

  $('#home-points').innerHTML =
    '<div class="gp-row"><span class="gp-label">ポイント残高</span>' +
    '<span class="gp-value">' + points.toLocaleString('ja-JP') + '<small>pt</small></span></div>' +
    '<div class="gp-row" style="margin-top:9px"><span class="gp-next" style="margin:0">いまの還元率</span>' +
    '<span class="gp-rate">100円 = ' + r.rate + 'pt</span></div>';
}

/* ---------- 定期情報 ---------- */
function renderSubs(){
  const act = SUBSCRIPTIONS.filter(function(s){ return s.status === 'active'; });
  const cnl = SUBSCRIPTIONS.filter(function(s){ return s.status === 'cancelled'; });

  function card(s){
    const cancelled = s.status === 'cancelled';
    const chip = cancelled
      ? '<span class="chip chip-gray chip-dot">解約済み</span>'
      : '<span class="chip chip-gold chip-dot">注文継続中</span>';
    const rows = cancelled
      ? '<dt>最終お届け</dt><dd>' + s.last + '</dd>'
      : '<dt>次回お届け</dt><dd>' + s.next + '</dd>';
    return '<div class="card sub-card' + (cancelled ? ' is-cancelled' : '') + '">' +
      '<div class="sub-thumb"><img src="' + s.img + '" alt=""></div>' +
      '<div class="sub-main">' +
        '<div class="sub-head"><p class="sub-name">' + s.name + '</p>' + chip + '</div>' +
        '<dl class="sub-rows">' + rows +
          '<dt>お届けサイクル</dt><dd>' + s.cycle + '</dd>' +
          '<dt>個数</dt><dd>' + s.qty + '個</dd>' +
          '<dt>ご注文金額</dt><dd class="price">' + yen(s.price) + ' <small style="font-size:9px;color:#A39A88">(税込)</small></dd>' +
        '</dl>' +
      '</div></div>';
  }
  $('#sub-list').innerHTML =
    '<p class="sec-label">ご利用中の定期コース</p>' + act.map(card).join('') +
    '<p class="sec-label">解約済みの定期コース</p>' + cnl.map(card).join('');
}

/* ---------- 購入履歴 ---------- */
function renderHistory(){
  $('#history-list').innerHTML = ORDERS.map(function(o){
    const chSub = o.chSub ? '<span class="chip chip-line">' + o.chSub + '</span>' : '';
    const kindChip = (o.kind === '定期購入')
      ? '<span class="chip chip-gold">定期購入</span>'
      : '<span class="chip chip-line">通常購入</span>';
    return '<div class="card order-card">' +
      '<div class="order-top">' +
        '<p class="order-date"><small>出荷日</small>' + o.date + '</p>' +
        '<p class="order-no">注文番号 ' + o.no + '</p>' +
      '</div>' +
      '<div class="order-mid">' +
        '<div class="order-thumb"><img src="' + o.img + '" alt=""></div>' +
        '<div class="order-info">' +
          '<p class="order-name">' + o.name + '</p>' +
          '<div class="order-chips">' + kindChip +
            '<span class="chip chip-line">' + o.ch + '</span>' + chSub +
          '</div>' +
        '</div>' +
      '</div>' +
      '<div class="order-bottom">' +
        '<span class="order-qty">数量 ' + o.qty + '点</span>' +
        '<span class="order-price">' + yen(o.price) + '<small>(税込)</small></span>' +
      '</div></div>';
  }).join('');
}

/* ---------- ストアーズ ---------- */
function storePhoto(s, cls){
  if (s.img){
    return '<img src="' + s.img + '" class="' + (s.imgClass || '') + '" alt="">';
  }
  return '<div style="width:100%;height:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;' +
    'background:linear-gradient(135deg,#2A2620,#4A3F2E)">' +
    '<div style="width:44px">' + swallowSVG('#C9B083', .9) + '</div>' +
    '<span style="font-family:serif;font-size:10px;letter-spacing:.3em;color:#D9C8A8">POP UP STORE</span></div>';
}

function renderStoresList(){
  $('#stores-list').innerHTML = STORES.map(function(s){
    const period = s.period ? '<p class="store-addr" style="color:#8A6E42;font-weight:700">' + s.period + '</p>' : '';
    return '<div class="card store-card" data-store="' + s.id + '">' +
      '<div class="store-photo">' + storePhoto(s) +
        '<span class="store-dist">現在地から ' + s.dist + '</span>' +
      '</div>' +
      '<div class="store-body">' +
        '<div class="store-head">' +
          '<p class="store-name">' + s.name + '</p>' +
          '<span class="chip ' + (s.type === '直営店' ? 'chip-gold' : s.type === '期間限定' ? 'chip-gray' : 'chip-line') + '">' + s.type + '</span>' +
        '</div>' + period +
        '<p class="store-addr">' + s.addr + '</p>' +
      '</div></div>';
  }).join('');
}

function renderStoresMap(){
  const pins = [
    { city:'tokyo', x:282, y:222, count:3, label:'TOKYO' },
    { city:'kyoto', x:214, y:272, count:2, label:'KYOTO' }
  ];
  $('#map-canvas').innerHTML = japanMapSVG(pins);
  $('#map-cards').innerHTML = STORES.map(function(s){
    const thumb = s.img
      ? '<img src="' + s.img + '" alt="">'
      : '<div style="width:54px;height:54px;border-radius:9px;flex:none;display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg,#2A2620,#4A3F2E)"><div style="width:28px">' + swallowSVG('#C9B083',.9) + '</div></div>';
    return '<button type="button" class="map-card" data-store="' + s.id + '" data-city="' + s.city + '">' + thumb +
      '<div style="text-align:left;min-width:0">' +
        '<p class="map-card-name">' + s.name + '</p>' +
        '<p class="map-card-meta">' + s.dist + '・' + s.type + '</p>' +
      '</div></button>';
  }).join('');
}

function selectCity(city){
  const cards = document.querySelectorAll('.map-card');
  let first = null;
  cards.forEach(function(c){
    const hit = c.dataset.city === city;
    c.classList.toggle('is-sel', hit);
    if (hit && !first) first = c;
  });
  if (first) first.scrollIntoView({ behavior:'smooth', inline:'start', block:'nearest' });
}

function setStoresView(v){
  state.storesView = v;
  $('#stores-list').classList.toggle('is-hidden', v !== 'list');
  $('#stores-map').classList.toggle('is-hidden', v !== 'map');
  document.querySelectorAll('#view-toggle button').forEach(function(b){
    b.classList.toggle('is-on', b.dataset.view === v);
  });
}

/* 店舗詳細 */
function openStoreDetail(id){
  const s = STORES.find(function(x){ return x.id === id; });
  if (!s) return;
  const d = $('#store-detail');
  const rows = [];
  if (s.period) rows.push(['開催期間', '<b style="color:#8A6E42">' + s.period + '</b>']);
  rows.push(['営業時間', s.hours]);
  rows.push(['定休日', s.closed]);
  if (s.tel) rows.push(['電話番号', s.tel]);
  rows.push(['住所', s.addr + '<small>現在地から ' + s.dist + '（ダミー距離）</small>']);

  d.innerHTML =
    '<div class="sd-hero">' + storePhoto(s) +
      '<button type="button" class="sd-back" id="sd-back" aria-label="戻る">' +
        '<svg viewBox="0 0 24 24"><path d="M15 5l-7 7 7 7"/></svg></button>' +
    '</div>' +
    '<div class="sd-body">' +
      '<div class="sd-head"><h3 class="sd-name">' + s.name + '</h3>' +
        '<span class="chip ' + (s.type === '直営店' ? 'chip-gold' : s.type === '期間限定' ? 'chip-gray' : 'chip-line') + '">' + s.type + '</span></div>' +
      '<p class="sd-en">' + s.en + '</p>' +
      '<p class="sd-desc">' + s.desc + '</p>' +
      '<p class="sd-sec">店舗情報</p>' +
      '<div class="card sd-info">' + rows.map(function(r){
          return '<div class="sd-row"><dt>' + r[0] + '</dt><dd>' + r[1] + '</dd></div>';
        }).join('') + '</div>' +
      (s.plan
        ? '<p class="sd-sec">フロアマップ</p><div class="sd-map">' + FLOORPLANS[s.plan] + '</div>' +
          '<p class="sd-map-note">※' + s.planNote + '・モックアップ用の概略図です</p>'
        : '') +
      '<p class="sd-sec">アクセス</p>' +
      '<div class="card sd-info">' + s.access.map(function(a){
          return '<div class="sd-row"><dt>経路</dt><dd>' + a + '</dd></div>';
        }).join('') + '</div>' +
      '<button type="button" class="sd-cta">マップアプリで経路を見る（モック）</button>' +
    '</div>';
  d.classList.remove('is-hidden');
  requestAnimationFrame(function(){ d.classList.add('is-open'); });
  $('#sd-back').addEventListener('click', function(){ closeStoreDetail(); });
  document.body.dataset.sb = 'light';
}

function closeStoreDetail(instant){
  const d = $('#store-detail');
  if (d.classList.contains('is-hidden')) return;
  d.classList.remove('is-open');
  if (instant){
    d.classList.add('is-hidden');
  } else {
    setTimeout(function(){ d.classList.add('is-hidden'); }, 340);
    document.body.dataset.sb = (state.screen === 'home') ? 'light' : 'dark';
  }
}

/* ---------- ランク切替ドック（スマホ枠の外・デザイン確認用） ---------- */
function renderRankDock(){
  const dock = $('#rank-dock');
  if (!dock) return;
  const rsItems = RANK_ORDER.map(function(id){
    const rk = RANKS[id];
    return '<button type="button" class="rs-item' + (id === state.rank ? ' is-on' : '') + '"' +
      ' style="--rs-c:' + rk.color + '" data-rank="' + id + '">' +
      swallowSVG(rk.color) + '<span>' + rk.en + '</span></button>';
  }).join('');
  dock.innerHTML =
    '<p class="rs-title">会員ランク切替<span class="rs-tag">デザイン確認用</span></p>' +
    '<p class="rs-note">タップで起動演出からリプレイ＆ホームのデザインが切り替わります</p>' +
    '<div class="rs-grid">' + rsItems + '</div>' +
    '<button type="button" class="dock-auth-demo" id="btn-auth-demo">ログイン画面デモ</button>';
}

/* ---------- 設定 ---------- */
function renderSettings(){
  const arrow = '<svg class="set-arrow" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7"/></svg>';
  const rows = [
    ['会員情報の変更', 'M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm-7 9a7 7 0 0 1 14 0'],
    ['お支払い方法', 'M3 7h18v11H3Zm0 4h18M6 14.5h4'],
    ['お届け先の管理', 'M12 21s-7-5.3-7-11a7 7 0 0 1 14 0c0 5.7-7 11-7 11Zm0-8.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z'],
    ['BI-SUについて', 'M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2Zm1 15h-2v-6h2Zm0-8h-2V7h2Z'],
    ['お問い合わせ', 'M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2Z'],
    ['よくあるご質問', 'M9.2 9a3 3 0 0 1 5.8 1c0 2-3 2.2-3 4M12 17.5h.01M12 21a9 9 0 1 1 9-9 9 9 0 0 1-9 9Z'],
    ['利用規約・プライバシーポリシー', 'M7 3h7l4 4v14H7ZM14 3v4h4M10 12h5M10 16h5'],
    ['アプリについて', 'M13 16h-1v-4h-1m1-4h.01M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z']
  ];

  $('#settings-body').innerHTML =
    '<div class="card profile-card">' +
      '<div class="avatar">' + MEMBER.initials + '</div>' +
      '<div><p class="profile-name">' + MEMBER.name + ' 様</p>' +
      '<p class="profile-meta">会員番号 ' + MEMBER.no + '<br>' + MEMBER.mail + '・' + MEMBER.since + 'ご入会</p></div>' +
    '</div>' +

    '<p class="sec-label">通知設定</p>' +
    '<div class="card set-list">' +
      '<div class="set-row"><svg class="set-ic" viewBox="0 0 24 24"><path d="M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6Zm4.5 9a1.8 1.8 0 0 0 3 0"/></svg>' +
        '<div class="set-label">お知らせ通知</div><button type="button" class="toggle is-on"></button></div>' +
      '<div class="set-row"><svg class="set-ic" viewBox="0 0 24 24"><path d="M3 8l9 5 9-5M4 6h16v12H4Z"/></svg>' +
        '<div class="set-label">お届け予定のリマインド<p class="set-sub">定期コースの出荷前にお知らせします</p></div><button type="button" class="toggle is-on"></button></div>' +
      '<div class="set-row"><svg class="set-ic" viewBox="0 0 24 24"><path d="M20 12a8 8 0 1 0-14.9 4L4 21l5-1.1A8 8 0 0 0 20 12Z"/></svg>' +
        '<div class="set-label">キャンペーン情報</div><button type="button" class="toggle"></button></div>' +
    '</div>' +

    '<p class="sec-label">アカウント</p>' +
    '<div class="card set-list">' +
      rows.map(function(row){
        return '<button type="button" class="set-row">' +
          '<svg class="set-ic" viewBox="0 0 24 24"><path d="' + row[1] + '"/></svg>' +
          '<div class="set-label">' + row[0] + '</div>' + arrow + '</button>';
      }).join('') +
    '</div>' +

    '<p class="sec-label">言語 / Language</p>' +
    '<div class="card set-list">' +
      '<div class="set-row"><svg class="set-ic" viewBox="0 0 24 24"><path d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20ZM2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10A15.3 15.3 0 0 1 12 2Z"/></svg>' +
        '<div class="set-label">日本語<p class="set-sub">Japanese</p></div>' +
        '<div class="lang-badge">選択中</div></button></div>' +
      '<div class="set-row"><svg class="set-ic" viewBox="0 0 24 24"><path d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20ZM2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10A15.3 15.3 0 0 1 12 2Z"/></svg>' +
        '<div class="set-label">English</div></div>' +
    '</div>' +

    '<p class="sec-label">その他</p>' +
    '<div class="card set-list">' +
      '<button type="button" class="set-row" id="btn-logout"><svg class="set-ic" viewBox="0 0 24 24" style="stroke:#A04545"><path d="M9 21H5V3h4M14 16l4-4-4-4M18 12H9"/></svg>' +
        '<div class="set-label" style="color:#A04545">ログアウト</div></button>' +
      '<button type="button" class="set-row" id="btn-delete-account"><svg class="set-ic" viewBox="0 0 24 24" style="stroke:#A04545"><path d="M3 6h18M8 6V4h8v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6M10 11v6M14 11v6"/></svg>' +
        '<div class="set-label" style="color:#A04545">アカウントを削除</div></button>' +
    '</div>' +

    '<p class="set-footer">BI-SU Member\'s App（モックアップ）v0.3.0<br>表示されている会員情報・注文・距離はすべてダミーです</p>';

  /* トグル（見た目のみ） */
  document.querySelectorAll('.toggle').forEach(function(t){
    t.addEventListener('click', function(){ t.classList.toggle('is-on'); });
  });
  var logoutBtn = $('#btn-logout');
  if (logoutBtn) logoutBtn.addEventListener('click', function(){ showDialog('dlg-logout'); });
  var deleteBtn = $('#btn-delete-account');
  if (deleteBtn) deleteBtn.addEventListener('click', function(){ showDialog('dlg-delete'); });
}

/* ---------- 会員証バーコード ---------- */
function generateBarcodeSVG(data){
  var code = '';
  for (var i = 0; i < data.length; i++){
    var c = data.charCodeAt(i);
    var bits = c.toString(2);
    while (bits.length < 8) bits = '0' + bits;
    code += bits;
  }
  code = '101' + code + '101';
  var w = code.length * 2;
  var svg = '<svg viewBox="0 0 ' + w + ' 80" xmlns="http://www.w3.org/2000/svg">';
  for (var j = 0; j < code.length; j++){
    if (code[j] === '1'){
      svg += '<rect x="' + (j * 2) + '" y="0" width="2" height="80" fill="#2A2620"/>';
    }
  }
  svg += '</svg>';
  return svg;
}
function openQR(){
  const r = rank();
  var barcodeData = 'BISU-' + MEMBER.no;
  $('#qr-card').innerHTML =
    '<div class="qr-rankline">' + swallowSVG(r.color) +
      '<span class="qr-rank-en">' + r.en + '</span></div>' +
    '<p class="qr-title">デジタル会員証</p>' +
    '<div class="qr-box barcode-box">' + generateBarcodeSVG(barcodeData) + '</div>' +
    '<p class="qr-no">' + MEMBER.no + '</p>' +
    '<p class="qr-name">' + MEMBER.name + ' 様</p>' +
    '<p class="qr-hint">店舗でのお会計・ポイント付与の際にご提示ください<br>（モックアップ用のダミーバーコードです）</p>' +
    '<button type="button" class="qr-close" id="qr-close">閉じる</button>';
  const m = $('#qr-modal');
  m.classList.remove('is-hidden');
  requestAnimationFrame(function(){ m.classList.add('is-open'); });
  $('#qr-close').addEventListener('click', closeQR);
}
function closeQR(){
  const m = $('#qr-modal');
  m.classList.remove('is-open');
  setTimeout(function(){ m.classList.add('is-hidden'); }, 330);
}

/* ---------- 認証フローデモ ---------- */
function showLogin(){
  $('#screen-login').classList.remove('is-hidden');
  document.body.dataset.sb = 'dark';
  $('#login-input').value = 'y-hasebe@mstyle-j.co.jp';
}
function hideLogin(){
  $('#screen-login').classList.add('is-hidden');
}
function showAuthCode(){
  var val = $('#login-input').value || 'y-hasebe@mstyle-j.co.jp';
  var masked = val.indexOf('@') > 0
    ? val.charAt(0) + '***' + val.substring(val.indexOf('@'))
    : val.substring(0, 3) + '****' + val.substring(val.length - 4);
  $('#authcode-desc').innerHTML = masked + ' に<br>認証コードを送信しました';
  hideLogin();
  $('#screen-authcode').classList.remove('is-hidden');
  document.querySelectorAll('.code-digit').forEach(function(d){ d.value = ''; });
  $('#authcode-submit').disabled = true;
  startCountdown();
  setTimeout(function(){ document.querySelector('.code-digit[data-idx="0"]').focus(); }, 120);
}
function hideAuthCode(){
  $('#screen-authcode').classList.add('is-hidden');
  clearCountdown();
}
var countdownId = null;
function startCountdown(){
  clearCountdown();
  var sec = 120;
  var el = $('#auth-countdown');
  var resend = $('#authcode-resend');
  resend.disabled = true;
  function tick(){
    if (sec <= 0){
      el.textContent = '再送できます';
      resend.disabled = false;
      return;
    }
    var m = Math.floor(sec / 60);
    var s = sec % 60;
    el.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s + ' 後に再送可能';
    sec--;
    countdownId = setTimeout(tick, 1000);
  }
  tick();
}
function clearCountdown(){ if (countdownId){ clearTimeout(countdownId); countdownId = null; } }
function handleCodeDigit(e){
  var inp = e.target;
  if (!inp.classList.contains('code-digit')) return;
  var idx = parseInt(inp.dataset.idx);
  inp.value = inp.value.replace(/[^\d]/g, '').slice(-1);
  if (inp.value && idx < 5){
    document.querySelector('.code-digit[data-idx="' + (idx + 1) + '"]').focus();
  }
  var allFilled = true;
  document.querySelectorAll('.code-digit').forEach(function(d){ if (!d.value) allFilled = false; });
  $('#authcode-submit').disabled = !allFilled;
}
function handleCodeKey(e){
  if (e.key === 'Backspace' && !e.target.value){
    var idx = parseInt(e.target.dataset.idx);
    if (idx > 0) document.querySelector('.code-digit[data-idx="' + (idx - 1) + '"]').focus();
  }
}

/* ---------- オンボーディング ---------- */
function showOnboarding(){
  hideAuthCode();
  state.obPage = 0;
  $('#screen-onboarding').classList.remove('is-hidden');
  document.body.dataset.sb = 'light';
  updateObPage();
}
function updateObPage(){
  var pages = document.querySelectorAll('.ob-page');
  pages.forEach(function(p, i){
    p.style.transform = 'translateX(' + ((i - state.obPage) * 100) + '%)';
  });
  document.querySelectorAll('.ob-dot').forEach(function(d, i){
    d.classList.toggle('is-on', i === state.obPage);
  });
  $('#ob-next').textContent = state.obPage >= pages.length - 1 ? 'はじめる' : '次へ';
}
function nextOnboarding(){
  var pages = document.querySelectorAll('.ob-page');
  if (state.obPage >= pages.length - 1){
    finishOnboarding();
  } else {
    state.obPage++;
    updateObPage();
  }
}
function finishOnboarding(){
  $('#screen-onboarding').classList.add('is-hidden');
  document.body.dataset.sb = 'light';
  playSplash();
}

/* ---------- 確認ダイアログ ---------- */
function showDialog(id){
  $('#' + id).classList.remove('is-hidden');
}
function hideDialog(id){
  $('#' + id).classList.add('is-hidden');
}
function handleLogout(){
  hideDialog('dlg-logout');
  showLogin();
}
function handleDeleteAccount(){
  hideDialog('dlg-delete');
  showLogin();
}

/* ---------- 初期化 ---------- */
function init(){
  buildTabbar();
  renderSubs();
  renderHistory();
  renderStoresList();
  renderStoresMap();
  setStoresView('list');
  setRank(state.rank, false);
  go('home');

  $('#qr-btn').addEventListener('click', openQR);
  $('#qr-backdrop').addEventListener('click', closeQR);
  $('#splash-skip').addEventListener('click', function(){ (state.skipFn || finishSplash)(); });
  $('#rank-dock').addEventListener('click', function(e){
    const b = e.target.closest('.rs-item');
    if (b && b.dataset.rank !== state.rank) setRank(b.dataset.rank, true);
  });
  $('#view-toggle').addEventListener('click', function(e){
    const b = e.target.closest('[data-view]');
    if (b) setStoresView(b.dataset.view);
  });
  $('#stores-list').addEventListener('click', function(e){
    const c = e.target.closest('[data-store]');
    if (c) openStoreDetail(c.dataset.store);
  });
  $('#map-cards').addEventListener('click', function(e){
    const c = e.target.closest('[data-store]');
    if (c) openStoreDetail(c.dataset.store);
  });
  $('#map-canvas').addEventListener('click', function(e){
    const p = e.target.closest('.map-pin');
    if (p) selectCity(p.dataset.city);
  });

  /* 認証フロー */
  $('#login-skip').addEventListener('click', function(){ hideLogin(); finishSplash(); });
  $('#login-submit').addEventListener('click', showAuthCode);
  $('#authcode-back').addEventListener('click', function(){ hideAuthCode(); showLogin(); });
  $('#authcode-submit').addEventListener('click', showOnboarding);
  $('#authcode-resend').addEventListener('click', startCountdown);
  $('#code-boxes').addEventListener('input', handleCodeDigit);
  $('#code-boxes').addEventListener('keydown', handleCodeKey);
  $('#ob-next').addEventListener('click', nextOnboarding);
  $('#ob-skip').addEventListener('click', finishOnboarding);

  /* ダイアログ */
  $('#dlg-logout-cancel').addEventListener('click', function(){ hideDialog('dlg-logout'); });
  $('#dlg-logout-ok').addEventListener('click', handleLogout);
  $('#dlg-delete-cancel').addEventListener('click', function(){ hideDialog('dlg-delete'); });
  $('#dlg-delete-ok').addEventListener('click', handleDeleteAccount);

  /* デモ */
  $('#btn-auth-demo').addEventListener('click', showLogin);

  playSplash();
}

document.addEventListener('DOMContentLoaded', init);
