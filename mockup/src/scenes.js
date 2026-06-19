/* ============================================================
   BI-SU Member's App Mockup — シーンアート
   起動ズーム演出の6シーン（ボルネオの旅）+ 地図 + 店舗見取り図
   すべてSVG（後から実写真レイヤーに差し替え可能な構造）
   ============================================================ */

/* ツバメシルエット（公式ランクアイコンのモチーフを簡略化した線画） */
const SWALLOW_PATH =
  'M8 14 C22 6 36 14 44 26 C47 22 52 21 56 25 ' +
  'C66 14 82 8 96 10 C84 16 74 22 66 32 ' +
  'C62 37 59 44 57 52 C55 60 52 66 47 70 ' +
  'C48 62 48 54 46 47 C42 50 36 52 30 52 ' +
  'C36 47 40 42 41 36 C30 36 16 28 8 14 Z';

function swallowSVG(color, opacity){
  const op = opacity == null ? 1 : opacity;
  return '<svg viewBox="0 0 100 80" xmlns="http://www.w3.org/2000/svg">' +
    '<path d="' + SWALLOW_PATH + '" fill="' + color + '" opacity="' + op + '"/></svg>';
}
/* シーン内に小さなツバメを置くためのパーツ */
function birds(list, color, baseOp){
  return list.map(function(b){
    return '<path d="' + SWALLOW_PATH + '" fill="' + (b.c || color) + '" opacity="' + (b.o != null ? b.o : baseOp) + '"' +
      ' transform="translate(' + b.x + ' ' + b.y + ') rotate(' + (b.r || 0) + ') scale(' + b.s + ')"/>';
  }).join('');
}

const SVG_OPEN = '<svg class="scene" viewBox="0 0 390 844" preserveAspectRatio="xMidYMid slice" xmlns="http://www.w3.org/2000/svg">';

/* ------------------------------------------------------------
   SCENE 1 — 上空（成層圏からボルネオ島を望む）
   ------------------------------------------------------------ */
const SCENE_AERIAL = SVG_OPEN +
'<defs>' +
 '<linearGradient id="aaSky" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#091430"/><stop offset=".32" stop-color="#173559"/>' +
  '<stop offset=".58" stop-color="#41719B"/><stop offset=".74" stop-color="#9FC4D8"/>' +
 '</linearGradient>' +
 '<linearGradient id="aaSea" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#86B3C4"/><stop offset=".28" stop-color="#2E6883"/>' +
  '<stop offset=".7" stop-color="#123A52"/><stop offset="1" stop-color="#0A2438"/>' +
 '</linearGradient>' +
 '<radialGradient id="aaSun" cx=".5" cy=".5" r=".5">' +
  '<stop offset="0" stop-color="#FFEFC9" stop-opacity=".95"/>' +
  '<stop offset=".4" stop-color="#FFD9A0" stop-opacity=".45"/>' +
  '<stop offset="1" stop-color="#FFD9A0" stop-opacity="0"/>' +
 '</radialGradient>' +
 '<radialGradient id="aaVig" cx=".5" cy=".42" r=".75">' +
  '<stop offset=".55" stop-color="#060A12" stop-opacity="0"/>' +
  '<stop offset="1" stop-color="#060A12" stop-opacity=".5"/>' +
 '</radialGradient>' +
 '<filter id="aaB1" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="6"/></filter>' +
 '<filter id="aaB2" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="14"/></filter>' +
'</defs>' +
'<rect width="390" height="540" fill="url(#aaSky)"/>' +
'<rect y="520" width="390" height="324" fill="url(#aaSea)"/>' +
'<rect y="498" width="390" height="46" fill="#C9DEE7" opacity=".4" filter="url(#aaB2)"/>' +
'<circle cx="307" cy="166" r="150" fill="url(#aaSun)"/>' +
'<circle cx="307" cy="166" r="22" fill="#FFF6E0" opacity=".9" filter="url(#aaB1)"/>' +
'<g fill="#FFFFFF">' +
 '<circle cx="44" cy="62" r="1.1" opacity=".7"/><circle cx="120" cy="34" r=".9" opacity=".5"/>' +
 '<circle cx="210" cy="74" r="1" opacity=".6"/><circle cx="86" cy="120" r=".8" opacity=".45"/>' +
 '<circle cx="320" cy="48" r=".9" opacity=".5"/><circle cx="266" cy="96" r=".7" opacity=".4"/>' +
'</g>' +
/* 雲の帯 */
'<g fill="#F4F8FA" filter="url(#aaB1)">' +
 '<ellipse cx="70" cy="300" rx="85" ry="14" opacity=".34"/>' +
 '<ellipse cx="150" cy="318" rx="60" ry="10" opacity=".26"/>' +
 '<ellipse cx="330" cy="262" rx="95" ry="15" opacity=".3"/>' +
 '<ellipse cx="262" cy="372" rx="70" ry="11" opacity=".24"/>' +
 '<ellipse cx="40" cy="412" rx="62" ry="10" opacity=".2"/>' +
 '<ellipse cx="348" cy="430" rx="58" ry="9" opacity=".18"/>' +
'</g>' +
/* 海面のきらめき */
'<g stroke="#EAF6FC" stroke-linecap="round">' +
 '<line x1="150" y1="588" x2="212" y2="588" stroke-width="1.6" opacity=".16"/>' +
 '<line x1="176" y1="612" x2="246" y2="612" stroke-width="1.4" opacity=".12"/>' +
 '<line x1="120" y1="648" x2="186" y2="648" stroke-width="1.6" opacity=".1"/>' +
 '<line x1="208" y1="684" x2="284" y2="684" stroke-width="1.8" opacity=".09"/>' +
 '<line x1="92" y1="724" x2="150" y2="724" stroke-width="1.6" opacity=".07"/>' +
'</g>' +
/* ボルネオ島（遠景シルエット） */
'<g>' +
 '<path d="M128 566 C140 552 158 546 172 548 C180 540 196 536 210 540 C224 534 242 538 252 548 C262 546 272 552 276 560 C282 564 280 570 274 572 L130 572 C124 570 124 569 128 566 Z" fill="#11332A"/>' +
 '<path d="M150 566 C158 556 172 552 184 555 C194 548 210 548 220 554 C232 550 244 556 250 564 L248 568 L152 568 Z" fill="#1B4A38" opacity=".85"/>' +
 '<path d="M128 574 C170 582 240 582 276 574 L276 580 C240 590 168 590 128 580 Z" fill="#0E2C3E" opacity=".5" filter="url(#aaB1)"/>' +
'</g>' +
birds([{x:96,y:282,s:.1,r:-12,o:.5},{x:118,y:296,s:.07,r:6,o:.45},{x:138,y:284,s:.08,r:-4,o:.4},{x:108,y:312,s:.06,r:10,o:.35}], '#0B1626') +
/* 手前の雲（フレーム） */
'<g fill="#EDF3F6" filter="url(#aaB2)">' +
 '<ellipse cx="20" cy="806" rx="170" ry="44" opacity=".5"/>' +
 '<ellipse cx="380" cy="116" rx="150" ry="38" opacity=".34"/>' +
'</g>' +
'<rect width="390" height="844" fill="url(#aaVig)"/>' +
'</svg>';

/* ------------------------------------------------------------
   SCENE 2 — ボルネオ島（島の全景）
   ------------------------------------------------------------ */
const SCENE_ISLAND = SVG_OPEN +
'<defs>' +
 '<linearGradient id="isSky" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#7FB4D4"/><stop offset="1" stop-color="#D7E9EF"/>' +
 '</linearGradient>' +
 '<linearGradient id="isSea" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#5FA9B5"/><stop offset=".3" stop-color="#2A7287"/>' +
  '<stop offset=".72" stop-color="#0F4763"/><stop offset="1" stop-color="#082E45"/>' +
 '</linearGradient>' +
 '<radialGradient id="isVig" cx=".5" cy=".45" r=".75">' +
  '<stop offset=".6" stop-color="#04141E" stop-opacity="0"/>' +
  '<stop offset="1" stop-color="#04141E" stop-opacity=".42"/>' +
 '</radialGradient>' +
 '<filter id="isB1" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="5"/></filter>' +
 '<filter id="isB2" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="12"/></filter>' +
'</defs>' +
'<rect width="390" height="250" fill="url(#isSky)"/>' +
'<rect y="230" width="390" height="614" fill="url(#isSea)"/>' +
'<rect y="222" width="390" height="30" fill="#E8F2F2" opacity=".5" filter="url(#isB1)"/>' +
'<g transform="translate(204 454) scale(.78) translate(-204 -454)">' +
/* 浅瀬の輪 */
'<path d="M70 470 C66 372 140 296 212 292 C290 288 342 352 338 442 C334 542 268 612 192 616 C112 620 74 556 70 470 Z" fill="none" stroke="#7FD9D6" stroke-width="22" opacity=".26" filter="url(#isB2)"/>' +
/* 島本体 */
'<g>' +
 '<path d="M84 468 C80 380 146 310 212 306 C282 302 326 360 324 440 C322 528 262 598 192 602 C120 606 88 548 84 468 Z" fill="#EFE0B4"/>' +
 '<path d="M92 468 C88 386 150 318 212 314 C276 310 318 364 316 440 C314 522 258 590 192 594 C126 598 96 544 92 468 Z" fill="#1E5034"/>' +
 '<path d="M120 430 C130 380 170 344 214 340 C258 336 292 372 294 420 C296 470 262 520 214 528 C162 536 112 488 120 430 Z" fill="#2A6B44"/>' +
 '<path d="M150 420 C160 388 188 366 216 366 C246 366 268 390 268 422 C268 458 242 488 210 492 C174 496 142 458 150 420 Z" fill="#388A57" opacity=".9"/>' +
 /* 山脈の陰影 */
 '<path d="M150 470 C176 430 206 404 246 380 L252 388 C214 414 188 442 162 480 Z" fill="#143C26" opacity=".4" filter="url(#isB1)"/>' +
 '<path d="M196 356 L210 332 L222 358 L236 340 L246 362" fill="none" stroke="#123622" stroke-width="5" stroke-linejoin="round" opacity=".55"/>' +
 /* 川の光 */
 '<path d="M206 470 C212 502 200 540 184 566" fill="none" stroke="#BFEAE2" stroke-width="2.4" opacity=".55"/>' +
'</g>' +
/* 白波 */
'<path d="M84 468 C80 380 146 310 212 306 C282 302 326 360 324 440 C322 528 262 598 192 602 C120 606 88 548 84 468 Z" fill="none" stroke="#FFFFFF" stroke-width="2.4" opacity=".5"/>' +
/* 雲影 */
'<g fill="#0B2A1C" filter="url(#isB2)">' +
 '<ellipse cx="170" cy="400" rx="44" ry="16" opacity=".12" transform="rotate(-18 170 400)"/>' +
 '<ellipse cx="250" cy="470" rx="38" ry="13" opacity=".1" transform="rotate(-12 250 470)"/>' +
'</g>' +
'</g>' +
/* 上空の雲 */
'<g fill="#FFFFFF" filter="url(#isB1)">' +
 '<ellipse cx="86" cy="246" rx="64" ry="11" opacity=".5"/>' +
 '<ellipse cx="318" cy="212" rx="58" ry="9" opacity=".42"/>' +
 '<ellipse cx="210" cy="700" rx="80" ry="12" opacity=".14"/>' +
'</g>' +
birds([{x:286,y:160,s:.09,r:-8,o:.5},{x:308,y:174,s:.06,r:4,o:.4}], '#1A3A4A') +
'<rect width="390" height="844" fill="url(#isVig)"/>' +
'</svg>';

/* ------------------------------------------------------------
   SCENE 3 — ジャングル（熱帯雨林の奥）
   ------------------------------------------------------------ */
const SCENE_JUNGLE = SVG_OPEN +
'<defs>' +
 '<linearGradient id="jgBg" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#0A2415"/><stop offset=".5" stop-color="#144026"/>' +
  '<stop offset="1" stop-color="#1E5430"/>' +
 '</linearGradient>' +
 '<linearGradient id="jgRay" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#F2FAC9" stop-opacity=".6"/>' +
  '<stop offset="1" stop-color="#F2FAC9" stop-opacity="0"/>' +
 '</linearGradient>' +
 '<radialGradient id="jgVig" cx=".5" cy=".45" r=".75">' +
  '<stop offset=".5" stop-color="#02100A" stop-opacity="0"/>' +
  '<stop offset="1" stop-color="#02100A" stop-opacity=".6"/>' +
 '</radialGradient>' +
 '<filter id="jgB1" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="4"/></filter>' +
 '<filter id="jgB2" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="13"/></filter>' +
 '<filter id="jgGlow" x="-200%" y="-200%" width="500%" height="500%"><feGaussianBlur stdDeviation="2.2"/></filter>' +
'</defs>' +
'<rect width="390" height="844" fill="url(#jgBg)"/>' +
/* 奥のキャノピー（ぼかし） */
'<g fill="#0B2818" filter="url(#jgB1)">' +
 '<path d="M0 120 C40 90 80 130 120 104 C160 80 200 120 240 98 C280 78 330 116 390 92 L390 0 L0 0 Z" opacity=".95"/>' +
 '<path d="M0 230 C50 200 96 244 150 218 C204 194 250 238 304 214 C340 200 368 222 390 212 L390 130 C330 156 280 118 240 140 C200 160 160 122 120 146 C80 168 40 132 0 162 Z" opacity=".7"/>' +
'</g>' +
/* 光芒 */
'<g filter="url(#jgB2)">' +
 '<polygon points="120,0 176,0 268,560 180,560" fill="url(#jgRay)" opacity=".55"/>' +
 '<polygon points="200,0 232,0 330,500 268,500" fill="url(#jgRay)" opacity=".34"/>' +
 '<polygon points="60,0 84,0 130,420 90,420" fill="url(#jgRay)" opacity=".26"/>' +
'</g>' +
/* 中景の葉 */
'<g fill="#17502C">' +
 '<path d="M0 360 C36 330 70 360 100 336 C130 316 160 344 186 326 L186 430 C140 452 60 448 0 420 Z" opacity=".9" filter="url(#jgB1)"/>' +
 '<path d="M390 320 C352 300 318 330 286 312 C260 298 234 318 216 308 L216 420 C270 444 346 436 390 404 Z" opacity=".85" filter="url(#jgB1)"/>' +
'</g>' +
/* 霧 */
'<rect y="392" width="390" height="78" fill="#D8EDD9" opacity=".11" filter="url(#jgB2)"/>' +
'<rect y="560" width="390" height="60" fill="#D8EDD9" opacity=".08" filter="url(#jgB2)"/>' +
/* 手前のシダ・ヤシ（シルエット） */
'<g fill="#03130A">' +
 '<path d="M-10 844 C0 720 20 640 58 580 C40 650 36 720 40 844 Z"/>' +
 '<path d="M58 580 C90 560 140 566 172 596 C134 588 96 592 66 606 Z"/>' +
 '<path d="M58 580 C84 544 126 530 162 540 C128 544 96 560 72 584 Z"/>' +
 '<path d="M58 580 C66 530 92 496 128 484 C100 502 82 534 74 572 Z"/>' +
 '<path d="M400 844 C394 700 380 620 336 552 C360 630 364 720 358 844 Z"/>' +
 '<path d="M336 552 C300 528 252 530 220 556 C258 548 298 554 326 572 Z"/>' +
 '<path d="M336 552 C320 504 286 480 246 478 C282 490 310 514 326 548 Z"/>' +
 '<path d="M0 0 C60 18 110 60 140 116 C100 80 50 48 0 38 Z"/>' +
 '<path d="M390 0 C330 14 282 50 252 102 C292 68 342 40 390 30 Z"/>' +
'</g>' +
/* 蔓 */
'<g fill="none" stroke="#04150C" stroke-width="2.6" stroke-linecap="round">' +
 '<path d="M96 0 C92 70 102 130 92 196 C86 236 92 268 100 292"/>' +
 '<path d="M312 0 C318 56 308 110 318 168 C324 204 318 232 308 254"/>' +
 '<path d="M150 0 C148 40 154 80 148 124"/>' +
'</g>' +
'<g fill="#0A2A16">' +
 '<ellipse cx="98" cy="200" rx="7" ry="3.4" transform="rotate(-24 98 200)"/>' +
 '<ellipse cx="92" cy="236" rx="6" ry="3" transform="rotate(18 92 236)"/>' +
 '<ellipse cx="316" cy="172" rx="7" ry="3.2" transform="rotate(22 316 172)"/>' +
 '<ellipse cx="148" cy="120" rx="6" ry="2.8" transform="rotate(-16 148 120)"/>' +
'</g>' +
/* 蛍・光の粒 */
'<g fill="#E9F7A8" filter="url(#jgGlow)">' +
 '<circle cx="140" cy="470" r="2" opacity=".9"/><circle cx="246" cy="430" r="1.6" opacity=".75"/>' +
 '<circle cx="186" cy="540" r="1.8" opacity=".85"/><circle cx="300" cy="498" r="1.4" opacity=".6"/>' +
 '<circle cx="96" cy="392" r="1.5" opacity=".65"/><circle cx="216" cy="620" r="1.7" opacity=".7"/>' +
 '<circle cx="158" cy="676" r="1.4" opacity=".55"/><circle cx="270" cy="580" r="1.2" opacity=".5"/>' +
'</g>' +
/* 地面の照り返し */
'<ellipse cx="206" cy="788" rx="150" ry="40" fill="#2E6F3D" opacity=".3" filter="url(#jgB2)"/>' +
'<rect width="390" height="844" fill="url(#jgVig)"/>' +
'</svg>';

/* ------------------------------------------------------------
   SCENE 4 — 洞窟の入り口
   ------------------------------------------------------------ */
const SCENE_CAVEMOUTH = SVG_OPEN +
'<defs>' +
 '<linearGradient id="cmBg" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#11271A"/><stop offset="1" stop-color="#1A3A26"/>' +
 '</linearGradient>' +
 '<linearGradient id="cmRock" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#4C4233"/><stop offset=".55" stop-color="#332B20"/>' +
  '<stop offset="1" stop-color="#211B13"/>' +
 '</linearGradient>' +
 '<radialGradient id="cmHole" cx=".5" cy=".62" r=".7">' +
  '<stop offset="0" stop-color="#23130A"/><stop offset=".55" stop-color="#0D0805"/>' +
  '<stop offset="1" stop-color="#020202"/>' +
 '</radialGradient>' +
 '<radialGradient id="cmVig" cx=".5" cy=".5" r=".74">' +
  '<stop offset=".5" stop-color="#020604" stop-opacity="0"/>' +
  '<stop offset="1" stop-color="#020604" stop-opacity=".62"/>' +
 '</radialGradient>' +
 '<filter id="cmB1" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="5"/></filter>' +
 '<filter id="cmB2" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="16"/></filter>' +
'</defs>' +
'<rect width="390" height="844" fill="url(#cmBg)"/>' +
/* 岩壁 */
'<path d="M0 96 C60 64 120 88 170 70 C230 50 300 76 390 58 L390 844 L0 844 Z" fill="url(#cmRock)"/>' +
/* 岩の地層線 */
'<g fill="none" stroke="#191510" stroke-width="2" opacity=".65" stroke-linecap="round">' +
 '<path d="M14 180 C90 158 160 176 232 158 C290 144 340 156 382 146"/>' +
 '<path d="M8 280 C70 262 130 278 196 262 C260 248 322 262 384 250"/>' +
 '<path d="M30 660 C90 676 150 664 210 678 C270 690 330 680 380 690"/>' +
 '<path d="M16 760 C80 776 160 766 230 780"/>' +
'</g>' +
/* 苔 */
'<g fill="#2E5230" filter="url(#cmB1)">' +
 '<ellipse cx="60" cy="128" rx="50" ry="12" opacity=".55"/>' +
 '<ellipse cx="210" cy="96" rx="62" ry="13" opacity=".5"/>' +
 '<ellipse cx="340" cy="120" rx="46" ry="11" opacity=".45"/>' +
 '<ellipse cx="130" cy="220" rx="30" ry="8" opacity=".3"/>' +
'</g>' +
/* 洞窟の開口部 */
'<path d="M104 720 C84 600 92 470 132 392 C160 338 232 332 262 388 C300 460 306 600 288 720 C284 752 270 768 240 772 L150 772 C122 768 110 752 104 720 Z" fill="url(#cmHole)"/>' +
/* 奥の灯り */
'<ellipse cx="196" cy="620" rx="74" ry="110" fill="#FF9D3A" opacity=".3" filter="url(#cmB2)"/>' +
'<ellipse cx="196" cy="656" rx="36" ry="54" fill="#FFC97E" opacity=".44" filter="url(#cmB2)"/>' +
'<ellipse cx="196" cy="680" rx="16" ry="24" fill="#FFE7C2" opacity=".4" filter="url(#cmB1)"/>' +
/* 開口部の縁の照り */
'<path d="M132 392 C160 338 232 332 262 388" fill="none" stroke="#6F5F46" stroke-width="3" opacity=".55" filter="url(#cmB1)"/>' +
'<path d="M110 660 C100 560 108 470 132 404" fill="none" stroke="#57492F" stroke-width="2" opacity=".35"/>' +
/* 蔓のカーテン */
'<g fill="none" stroke="#0D2114" stroke-width="2.6" stroke-linecap="round">' +
 '<path d="M150 348 C146 392 152 436 146 478"/>' +
 '<path d="M186 336 C184 372 190 408 184 446 C181 468 185 486 190 500"/>' +
 '<path d="M226 338 C230 376 224 412 230 452"/>' +
 '<path d="M258 360 C262 392 256 420 260 448"/>' +
'</g>' +
'<g fill="#10301C">' +
 '<ellipse cx="148" cy="482" rx="6.4" ry="3" transform="rotate(-20 148 482)"/>' +
 '<ellipse cx="190" cy="504" rx="6" ry="2.8" transform="rotate(14 190 504)"/>' +
 '<ellipse cx="229" cy="456" rx="6.4" ry="3" transform="rotate(-12 229 456)"/>' +
 '<ellipse cx="260" cy="452" rx="5.4" ry="2.6" transform="rotate(18 260 452)"/>' +
'</g>' +
/* 飛び立つアナツバメ */
birds([
 {x:196,y:470,s:.13,r:-18,c:'#1A1208',o:.95},
 {x:160,y:420,s:.17,r:-26,c:'#06090C',o:.95},
 {x:240,y:392,s:.2,r:14,c:'#06090C',o:.95},
 {x:120,y:330,s:.24,r:-10,c:'#05080A',o:.95},
 {x:286,y:300,s:.27,r:20,c:'#05080A',o:.95},
 {x:200,y:240,s:.3,r:-6,c:'#04070A',o:.95},
 {x:90,y:190,s:.2,r:-22,c:'#05080A',o:.85}
], '#05080A') +
/* 周囲のジャングル枠 */
'<g fill="#06150C">' +
 '<path d="M0 0 C50 30 86 90 96 170 C70 120 36 80 0 64 Z"/>' +
 '<path d="M390 0 C346 24 314 78 304 150 C330 104 360 70 390 52 Z"/>' +
 '<path d="M0 844 L0 700 C50 720 96 762 122 844 Z"/>' +
 '<path d="M390 844 L390 690 C336 714 296 760 274 844 Z"/>' +
'</g>' +
/* 漂う粒子 */
'<g fill="#E8D6A8" filter="url(#cmB1)">' +
 '<circle cx="186" cy="560" r="1.6" opacity=".6"/><circle cx="216" cy="600" r="1.3" opacity=".5"/>' +
 '<circle cx="200" cy="520" r="1.2" opacity=".45"/>' +
'</g>' +
'<rect width="390" height="844" fill="url(#cmVig)"/>' +
'</svg>';

/* ------------------------------------------------------------
   SCENE 5 — 洞窟の内部（アナツバメの聖域）
   ------------------------------------------------------------ */
const SCENE_CAVE = SVG_OPEN +
'<defs>' +
 '<radialGradient id="cvBg" cx=".58" cy=".18" r="1.05">' +
  '<stop offset="0" stop-color="#14293A"/><stop offset=".5" stop-color="#0A1620"/>' +
  '<stop offset="1" stop-color="#04070B"/>' +
 '</radialGradient>' +
 '<linearGradient id="cvBeam" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#D6EDFA" stop-opacity=".58"/>' +
  '<stop offset=".62" stop-color="#9CC8DE" stop-opacity=".2"/>' +
  '<stop offset="1" stop-color="#9CC8DE" stop-opacity="0"/>' +
 '</linearGradient>' +
 '<radialGradient id="cvVig" cx=".5" cy=".46" r=".76">' +
  '<stop offset=".46" stop-color="#01040A" stop-opacity="0"/>' +
  '<stop offset="1" stop-color="#01040A" stop-opacity=".68"/>' +
 '</radialGradient>' +
 '<filter id="cvB1" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="4"/></filter>' +
 '<filter id="cvB2" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="13"/></filter>' +
'</defs>' +
'<rect width="390" height="844" fill="url(#cvBg)"/>' +
/* 天井の穴と光柱 */
'<ellipse cx="232" cy="66" rx="40" ry="15" fill="#E7F6FF" opacity=".95"/>' +
'<ellipse cx="232" cy="66" rx="64" ry="26" fill="#BFE3F4" opacity=".5" filter="url(#cvB2)"/>' +
'<polygon points="200,70 264,70 318,650 138,650" fill="url(#cvBeam)" filter="url(#cvB2)"/>' +
'<polygon points="216,70 248,70 282,640 176,640" fill="url(#cvBeam)" opacity=".7" filter="url(#cvB1)"/>' +
/* 床の光だまり */
'<ellipse cx="228" cy="652" rx="104" ry="26" fill="#BFE0EF" opacity=".3" filter="url(#cvB2)"/>' +
'<ellipse cx="228" cy="652" rx="48" ry="12" fill="#E2F3FB" opacity=".32" filter="url(#cvB1)"/>' +
/* 鍾乳石 */
'<g fill="#05080D">' +
 '<path d="M0 0 L390 0 L390 56 C360 50 348 96 330 60 C318 38 310 90 296 58 C288 42 282 72 270 52 L264 24 C240 60 232 28 214 56 C200 78 192 36 178 60 C162 88 152 44 136 66 C118 92 108 40 92 64 C76 88 66 44 48 70 C34 90 22 52 0 76 Z"/>' +
 '<path d="M118 0 C124 44 134 86 130 128 C126 162 116 186 104 198 C112 158 112 112 106 70 Z" opacity=".95"/>' +
 '<path d="M300 0 C306 36 314 72 310 110 C307 140 298 160 288 170 C296 134 296 96 290 58 Z" opacity=".95"/>' +
'</g>' +
'<g fill="none" stroke="#7FB4CC" stroke-width="1.6" opacity=".3" stroke-linecap="round">' +
 '<path d="M124 30 C128 64 132 100 128 136"/>' +
 '<path d="M306 24 C310 54 314 88 310 120"/>' +
'</g>' +
/* 左右の岩壁 */
'<g fill="#04060A">' +
 '<path d="M0 76 C40 120 64 200 58 300 C54 380 30 440 44 530 C56 610 30 690 0 730 Z"/>' +
 '<path d="M390 60 C356 130 340 220 352 320 C362 410 386 460 376 560 C368 640 384 710 390 740 Z"/>' +
'</g>' +
'<g fill="none" stroke="#5E94AC" stroke-width="1.8" opacity=".22" stroke-linecap="round">' +
 '<path d="M52 180 C56 250 48 320 52 392"/>' +
 '<path d="M360 200 C354 270 364 350 358 420"/>' +
'</g>' +
/* 壁面の巣（遠景・ほのかに光る） */
'<g>' +
 '<g fill="none" stroke="#E2C188" stroke-width="2" stroke-linecap="round" opacity=".75">' +
  '<path d="M66 332 C70 340 82 340 86 332"/>' +
  '<path d="M84 388 C88 396 100 396 104 388"/>' +
  '<path d="M60 444 C64 452 76 452 80 444"/>' +
  '<path d="M348 300 C344 308 332 308 328 300"/>' +
  '<path d="M362 372 C358 380 346 380 342 372"/>' +
  '<path d="M344 440 C340 448 328 448 324 440"/>' +
 '</g>' +
 '<g fill="#FFE9B0" filter="url(#cvB1)">' +
  '<circle cx="76" cy="334" r="2.6" opacity=".5"/><circle cx="94" cy="390" r="2.4" opacity=".45"/>' +
  '<circle cx="70" cy="446" r="2.2" opacity=".4"/><circle cx="338" cy="302" r="2.6" opacity=".5"/>' +
  '<circle cx="352" cy="374" r="2.2" opacity=".4"/><circle cx="334" cy="442" r="2" opacity=".38"/>' +
 '</g>' +
'</g>' +
/* 旋回するアナツバメの群れ */
'<ellipse cx="228" cy="400" rx="130" ry="170" fill="none" stroke="#9CC8DC" stroke-width="1" opacity=".08"/>' +
birds([
 {x:228,y:206,s:.16,r:-10,c:'#04060A'},
 {x:286,y:262,s:.13,r:24,c:'#8FC4DC',o:.85},
 {x:160,y:282,s:.18,r:-28,c:'#04060A'},
 {x:252,y:330,s:.11,r:10,c:'#A9D2E4',o:.8},
 {x:118,y:380,s:.14,r:-14,c:'#05080C'},
 {x:298,y:412,s:.16,r:18,c:'#04060A'},
 {x:206,y:438,s:.1,r:-6,c:'#BBDCEA',o:.85},
 {x:152,y:492,s:.13,r:-24,c:'#05080C'},
 {x:268,y:520,s:.12,r:12,c:'#8FC4DC',o:.7},
 {x:222,y:560,s:.09,r:4,c:'#05080C',o:.9},
 {x:96,y:300,s:.1,r:-20,c:'#05080C',o:.8},
 {x:330,y:350,s:.09,r:26,c:'#05080C',o:.75}
], '#04060A', .95) +
/* 光柱の中の塵 */
'<g fill="#DFF0FA">' +
 '<circle cx="222" cy="200" r="1.1" opacity=".8"/><circle cx="240" cy="260" r=".9" opacity=".6"/>' +
 '<circle cx="214" cy="330" r="1.2" opacity=".7"/><circle cx="252" cy="390" r=".8" opacity=".5"/>' +
 '<circle cx="230" cy="450" r="1" opacity=".6"/><circle cx="210" cy="520" r=".9" opacity=".45"/>' +
 '<circle cx="246" cy="560" r="1.1" opacity=".5"/><circle cx="226" cy="610" r=".8" opacity=".4"/>' +
'</g>' +
/* 床の岩 */
'<path d="M0 844 L0 700 C60 690 110 712 160 700 C220 686 280 706 330 694 C354 690 376 696 390 704 L390 844 Z" fill="#05070A"/>' +
'<path d="M120 700 C150 684 200 680 236 692 L228 706 C196 696 156 698 132 708 Z" fill="#0B141C" opacity=".8"/>' +
'<rect width="390" height="844" fill="url(#cvVig)"/>' +
'</svg>';

/* ------------------------------------------------------------
   SCENE 6 — ツバメの巣（神秘のクローズアップ）
   ------------------------------------------------------------ */
function nestArcs(){
  /* 巣のカップ: 重なり合う楕円弧で「編まれた」質感 */
  const arcs = [
    [195,470,86,26,'#D9AF74',3.2,.5],
    [195,478,82,24,'#EBC98C',2.6,.65],
    [195,486,78,23,'#D9AF74',3.4,.55],
    [195,494,73,21,'#F2D9A4',2.2,.75],
    [195,502,68,20,'#E2BC80',3,.6],
    [195,510,62,18,'#F6E2B4',2,.8],
    [195,518,56,16,'#E2BC80',2.8,.65],
    [195,526,49,14,'#F6E8C4',1.8,.85],
    [195,533,42,12,'#EBC98C',2.4,.7],
    [195,540,34,10,'#F9EFD2',1.6,.9],
    [195,546,26,8,'#EFD398',2,.75],
    [195,551,18,6,'#FBF3DC',1.4,.95]
  ];
  return arcs.map(function(a){
    return '<path d="M' + (a[0]-a[2]) + ' ' + a[1] +
      ' A' + a[2] + ' ' + a[3] + ' 0 0 0 ' + (a[0]+a[2]) + ' ' + a[1] + '"' +
      ' fill="none" stroke="' + a[4] + '" stroke-width="' + a[5] + '" opacity="' + a[6] + '" stroke-linecap="round"/>';
  }).join('');
}
function sparkle(x,y,s,o,c){
  return '<path d="M0 -7 L1.6 -1.6 L7 0 L1.6 1.6 L0 7 L-1.6 1.6 L-7 0 L-1.6 -1.6 Z"' +
    ' fill="' + (c||'#FFE9B0') + '" opacity="' + o + '" transform="translate(' + x + ' ' + y + ') scale(' + s + ')"/>';
}
const SCENE_NEST = SVG_OPEN +
'<defs>' +
 '<radialGradient id="nsBg" cx=".5" cy=".55" r=".95">' +
  '<stop offset="0" stop-color="#3A1B20"/><stop offset=".45" stop-color="#220E14"/>' +
  '<stop offset="1" stop-color="#0E0508"/>' +
 '</radialGradient>' +
 '<radialGradient id="nsHalo" cx=".5" cy=".5" r=".5">' +
  '<stop offset="0" stop-color="#FFDf9E" stop-opacity=".55"/>' +
  '<stop offset=".55" stop-color="#FFD98E" stop-opacity=".18"/>' +
  '<stop offset="1" stop-color="#FFD98E" stop-opacity="0"/>' +
 '</radialGradient>' +
 '<linearGradient id="nsRay" x1="0" y1="0" x2="0" y2="1">' +
  '<stop offset="0" stop-color="#FFE3B0" stop-opacity=".34"/>' +
  '<stop offset="1" stop-color="#FFE3B0" stop-opacity="0"/>' +
 '</linearGradient>' +
 '<radialGradient id="nsVig" cx=".5" cy=".5" r=".74">' +
  '<stop offset=".42" stop-color="#070205" stop-opacity="0"/>' +
  '<stop offset="1" stop-color="#070205" stop-opacity=".66"/>' +
 '</radialGradient>' +
 '<filter id="nsB1" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="4"/></filter>' +
 '<filter id="nsB2" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="15"/></filter>' +
 '<filter id="nsB3" x="-100%" y="-100%" width="300%" height="300%"><feGaussianBlur stdDeviation="7"/></filter>' +
'</defs>' +
'<rect width="390" height="844" fill="url(#nsBg)"/>' +
/* 上からの細い光 */
'<polygon points="158,0 232,0 268,560 130,560" fill="url(#nsRay)" filter="url(#nsB2)"/>' +
/* 巣のハロー */
'<circle cx="195" cy="498" r="180" fill="url(#nsHalo)"/>' +
'<circle cx="195" cy="498" r="92" fill="url(#nsHalo)" opacity=".9"/>' +
/* 岩棚 */
'<path d="M0 844 L0 620 C50 600 110 612 160 596 C150 620 150 650 162 676 C120 700 60 706 0 696 Z" fill="#0C0508"/>' +
'<path d="M390 844 L390 600 C340 586 290 598 240 588 C252 616 252 648 240 676 C290 698 348 702 390 692 Z" fill="#0C0508"/>' +
'<path d="M120 660 C160 636 240 636 282 662 C300 676 304 700 296 720 L104 720 C96 698 102 674 120 660 Z" fill="#140A0C"/>' +
'<path d="M120 660 C160 636 240 636 282 662" fill="none" stroke="#B86A55" stroke-width="2" opacity=".3" filter="url(#nsB1)"/>' +
/* 巣本体 */
'<ellipse cx="195" cy="514" rx="74" ry="42" fill="#FFF0C8" opacity=".22" filter="url(#nsB1)"/>' +
nestArcs() +
'<ellipse cx="195" cy="500" rx="44" ry="13" fill="#FFF6DC" opacity=".5" filter="url(#nsB1)"/>' +
'<ellipse cx="195" cy="498" rx="22" ry="7" fill="#FFFAE8" opacity=".85" filter="url(#nsB3)"/>' +
/* ほつれた糸 */
'<g fill="none" stroke="#EBC98C" stroke-width="1.4" opacity=".55" stroke-linecap="round">' +
 '<path d="M118 472 C108 482 102 496 104 512"/>' +
 '<path d="M274 466 C284 478 288 494 284 510"/>' +
 '<path d="M132 530 C126 542 126 554 132 566"/>' +
'</g>' +
/* 輝き */
sparkle(120,420,1,.9) + sparkle(286,440,.7,.75) + sparkle(232,372,.55,.65) +
sparkle(154,580,.6,.6) + sparkle(262,560,.8,.7) + sparkle(96,500,.5,.5) +
sparkle(318,500,.45,.45) + sparkle(195,330,.65,.8,'#FFF4D8') +
/* ボケ光 */
'<g filter="url(#nsB3)">' +
 '<circle cx="84" cy="360" r="9" fill="#E9899B" opacity=".22"/>' +
 '<circle cx="312" cy="396" r="11" fill="#FFD98E" opacity=".2"/>' +
 '<circle cx="100" cy="600" r="8" fill="#FFD98E" opacity=".18"/>' +
 '<circle cx="300" cy="620" r="10" fill="#E9899B" opacity=".16"/>' +
 '<circle cx="60" cy="470" r="6" fill="#FFE9B0" opacity=".2"/>' +
 '<circle cx="332" cy="540" r="7" fill="#FFE9B0" opacity=".18"/>' +
'</g>' +
/* 見守るアナツバメ */
birds([{x:118,y:636,s:.2,r:-8,c:'#150A0D',o:1}], '#150A0D') +
'<rect width="390" height="844" fill="url(#nsVig)"/>' +
'</svg>';

/* ------------------------------------------------------------
   シーン定義（ランク→2シーンのズーム連結）
   ------------------------------------------------------------ */
const SCENES = {
  aerial:    { svg: SCENE_AERIAL,    focus: [200, 565] },
  island:    { svg: SCENE_ISLAND,    focus: [204, 432] },
  jungle:    { svg: SCENE_JUNGLE,    focus: [196, 468] },
  cavemouth: { svg: SCENE_CAVEMOUTH, focus: [196, 500] },
  cave:      { svg: SCENE_CAVE,      focus: [228, 430] },
  nest:      { svg: SCENE_NEST,      focus: [195, 500] }
};

/* ------------------------------------------------------------
   ストアーズ: 日本地図（簡略スタイルマップ）
   ------------------------------------------------------------ */
function japanMapSVG(pins){
  const pinMarks = pins.map(function(p){
    return '<g class="map-pin" data-city="' + p.city + '" transform="translate(' + p.x + ' ' + p.y + ')">' +
      '<circle class="pin-pulse" r="16" fill="#A8895A" opacity=".4"/>' +
      '<circle r="11" fill="#8A6E42" stroke="#FBFAF6" stroke-width="2.5"/>' +
      '<text y="3.8" text-anchor="middle" font-size="10.5" font-weight="700" fill="#FFF" font-family="sans-serif">' + p.count + '</text>' +
      '<text y="30" text-anchor="middle" font-size="10" letter-spacing="2" fill="#6F6757" font-family="serif">' + p.label + '</text>' +
    '</g>';
  }).join('');
  return '<svg viewBox="0 0 390 430" xmlns="http://www.w3.org/2000/svg">' +
  '<defs>' +
   '<linearGradient id="mpSea" x1="0" y1="0" x2="1" y2="1">' +
    '<stop offset="0" stop-color="#EBE5D6"/><stop offset="1" stop-color="#DFD7C2"/>' +
   '</linearGradient>' +
  '</defs>' +
  '<rect width="390" height="430" fill="url(#mpSea)"/>' +
  /* 緯線・経線 */
  '<g stroke="#C9BFA6" stroke-width=".7" opacity=".5">' +
   '<line x1="0" y1="108" x2="390" y2="108"/><line x1="0" y1="216" x2="390" y2="216"/>' +
   '<line x1="0" y1="324" x2="390" y2="324"/><line x1="98" y1="0" x2="98" y2="430"/>' +
   '<line x1="196" y1="0" x2="196" y2="430"/><line x1="294" y1="0" x2="294" y2="430"/>' +
  '</g>' +
  /* 北海道 */
  '<path d="M296 44 C310 32 330 30 344 40 C358 48 362 64 354 76 C348 86 336 88 326 84 C320 92 308 94 300 88 C288 80 286 54 296 44 Z" fill="#F7F3E8" stroke="#C2B186" stroke-width="1.6"/>' +
  /* 本州 */
  '<path d="M318 102 C330 116 332 134 324 150 C314 170 296 180 286 198 C278 212 274 228 262 240 C250 252 234 256 222 266 C210 276 202 290 188 296 C172 304 156 302 144 310 C132 318 126 330 114 334 C104 338 94 332 92 322 C90 312 98 304 108 300 C120 294 130 286 140 278 C152 268 160 254 174 246 C188 238 200 230 210 218 C222 204 230 188 242 174 C254 160 270 152 280 138 C290 126 296 110 306 100 C310 96 314 98 318 102 Z" fill="#F7F3E8" stroke="#C2B186" stroke-width="1.6"/>' +
  /* 四国 */
  '<path d="M186 318 C196 312 210 314 216 322 C220 330 214 340 204 342 C194 344 184 340 182 332 C180 326 182 320 186 318 Z" fill="#F7F3E8" stroke="#C2B186" stroke-width="1.4"/>' +
  /* 九州 */
  '<path d="M118 340 C130 332 144 336 150 346 C156 356 152 370 142 378 C134 384 122 382 116 374 C108 364 108 348 118 340 Z" fill="#F7F3E8" stroke="#C2B186" stroke-width="1.4"/>' +
  /* 沖縄 */
  '<circle cx="56" cy="404" r="4" fill="#F7F3E8" stroke="#C2B186" stroke-width="1.2"/>' +
  '<circle cx="44" cy="414" r="2.4" fill="#F7F3E8" stroke="#C2B186" stroke-width="1"/>' +
  /* コンパス */
  '<g transform="translate(348 386)" opacity=".75">' +
   '<circle r="15" fill="none" stroke="#A8895A" stroke-width="1"/>' +
   '<path d="M0 -11 L3.4 4 L0 1.6 L-3.4 4 Z" fill="#A8895A"/>' +
   '<text y="-19" text-anchor="middle" font-size="8.5" fill="#8A6E42" font-family="serif">N</text>' +
  '</g>' +
  '<text x="20" y="32" font-size="11" letter-spacing="4" fill="#A8895A" font-family="serif">BI-SU STORE MAP</text>' +
  '<text x="372" y="416" text-anchor="end" font-size="8" fill="#A39A88">※簡略図（イメージ）</text>' +
  pinMarks +
  '</svg>';
}

/* ------------------------------------------------------------
   店舗見取り図（オリジナル簡略図）
   ------------------------------------------------------------ */
const PLAN_COMMON_STYLE =
 '<style>.pl-blk{fill:#EFE7D6;stroke:#D9CCB0;stroke-width:1;}' +
 '.pl-txt{font-family:sans-serif;fill:#8B8273;}' +
 '.pl-bisu{fill:#B89B66;}' +
 '.pl-route{fill:none;stroke:#A8895A;stroke-width:1.6;stroke-dasharray:4 3;}</style>';

const PLAN_GSIX =
'<svg viewBox="0 0 340 250" xmlns="http://www.w3.org/2000/svg">' + PLAN_COMMON_STYLE +
'<rect width="340" height="250" fill="#FBF8F2"/>' +
'<text x="20" y="28" font-size="13" letter-spacing="3" fill="#A8895A" font-family="serif">GINZA SIX — B1F</text>' +
'<rect x="20" y="40" width="300" height="178" rx="10" fill="#F6F1E6" stroke="#D9CCB0" stroke-width="1.4"/>' +
/* 通り側ラベル */
'<text class="pl-txt" x="12" y="134" font-size="8.5" transform="rotate(-90 12 134)" text-anchor="middle" letter-spacing="1">中央通り側</text>' +
'<text class="pl-txt" x="330" y="134" font-size="8.5" transform="rotate(90 330 134)" text-anchor="middle" letter-spacing="1">三原通り側</text>' +
/* 区画 */
'<rect class="pl-blk" x="34" y="54" width="64" height="44" rx="3"/>' +
'<rect class="pl-blk" x="240" y="54" width="66" height="64" rx="3"/>' +
'<rect class="pl-blk" x="34" y="112" width="64" height="50" rx="3"/>' +
'<rect class="pl-blk" x="34" y="172" width="100" height="34" rx="3"/>' +
'<rect class="pl-blk" x="160" y="172" width="146" height="34" rx="3"/>' +
'<rect class="pl-blk" x="240" y="128" width="66" height="34" rx="3"/>' +
/* 北側エスカレーター */
'<g transform="translate(166 64)">' +
 '<rect x="-28" y="-6" width="56" height="34" rx="4" fill="#E5DCC6" stroke="#C9B98F" stroke-width="1.2"/>' +
 '<path d="M-16 20 L-4 6 L4 6 M-8 20 L4 6 M8 6 L16 6" stroke="#8A6E42" stroke-width="1.8" fill="none" stroke-linecap="round"/>' +
 '<text class="pl-txt" y="-12" text-anchor="middle" font-size="8.5" letter-spacing="1">北側エスカレーター</text>' +
'</g>' +
/* BI-SU 区画 */
'<g transform="translate(166 136)">' +
 '<rect x="-42" y="-22" width="84" height="46" rx="5" class="pl-bisu"/>' +
 '<rect x="-42" y="-22" width="84" height="46" rx="5" fill="none" stroke="#8A6E42" stroke-width="1.6"/>' +
 '<path d="' + SWALLOW_PATH + '" fill="#FFF" opacity=".95" transform="translate(-30 -14) scale(.18)"/>' +
 '<text x="6" y="3" text-anchor="middle" font-size="12" letter-spacing="2.5" fill="#FFF" font-family="serif">BI-SU</text>' +
 '<text x="0" y="16" text-anchor="middle" font-size="6.5" letter-spacing="1.5" fill="#FFF7E6">GINZA SIX</text>' +
'</g>' +
/* 動線 */
'<path class="pl-route" d="M166 96 L166 110"/>' +
'<path d="M166 110 L162 104 L170 104 Z" fill="#A8895A"/>' +
'<text class="pl-txt" x="176" y="106" font-size="7.5">エスカレーターからすぐ</text>' +
'</svg>';

const PLAN_SALONE =
'<svg viewBox="0 0 340 190" xmlns="http://www.w3.org/2000/svg">' + PLAN_COMMON_STYLE +
'<rect width="340" height="190" fill="#FBF8F2"/>' +
'<text x="20" y="26" font-size="12" letter-spacing="3" fill="#A8895A" font-family="serif">TOKYO MIDTOWN — GALLERIA 2F</text>' +
'<rect x="20" y="38" width="300" height="124" rx="10" fill="#F6F1E6" stroke="#D9CCB0" stroke-width="1.4"/>' +
'<text class="pl-txt" x="170" y="52" text-anchor="middle" font-size="8" letter-spacing="2">ガーデン側</text>' +
'<rect class="pl-blk" x="34" y="60" width="52" height="36" rx="3"/>' +
'<rect class="pl-blk" x="96" y="60" width="52" height="36" rx="3"/>' +
'<rect class="pl-blk" x="222" y="60" width="40" height="36" rx="3"/>' +
'<rect class="pl-blk" x="272" y="60" width="34" height="36" rx="3"/>' +
'<rect x="34" y="104" width="272" height="18" fill="#EDE6D4"/>' +
'<text class="pl-txt" x="170" y="116" text-anchor="middle" font-size="7.5" letter-spacing="3">GALLERIA 回廊</text>' +
'<rect class="pl-blk" x="34" y="130" width="60" height="24" rx="3"/>' +
'<rect class="pl-blk" x="246" y="130" width="60" height="24" rx="3"/>' +
'<g transform="translate(185 78)">' +
 '<rect x="-27" y="-18" width="54" height="36" rx="4" class="pl-bisu"/>' +
 '<text y="-1" text-anchor="middle" font-size="9" letter-spacing="1.5" fill="#FFF" font-family="serif">BI-SU</text>' +
 '<text y="10" text-anchor="middle" font-size="5.5" letter-spacing="1" fill="#FFF7E6">ISETAN SALONE</text>' +
'</g>' +
'<g transform="translate(150 142)">' +
 '<path d="M-10 8 L0 -4 L6 -4 M-4 8 L6 -4" stroke="#8A6E42" stroke-width="1.6" fill="none" stroke-linecap="round"/>' +
 '<text class="pl-txt" x="14" y="6" font-size="7">エスカレーター</text>' +
'</g>' +
'</svg>';

const PLAN_ISETAN =
'<svg viewBox="0 0 340 190" xmlns="http://www.w3.org/2000/svg">' + PLAN_COMMON_STYLE +
'<rect width="340" height="190" fill="#FBF8F2"/>' +
'<text x="20" y="26" font-size="12" letter-spacing="3" fill="#A8895A" font-family="serif">伊勢丹新宿店 本館 — B2F</text>' +
'<rect x="20" y="38" width="300" height="124" rx="10" fill="#F6F1E6" stroke="#D9CCB0" stroke-width="1.4"/>' +
'<rect x="34" y="52" width="170" height="96" rx="6" fill="#F2E9DA" stroke="#D9C7A4" stroke-width="1.2" stroke-dasharray="5 4"/>' +
'<text class="pl-txt" x="119" y="68" text-anchor="middle" font-size="7.5" letter-spacing="1.5">ビューティーアポセカリー</text>' +
'<rect class="pl-blk" x="218" y="52" width="88" height="42" rx="3"/>' +
'<rect class="pl-blk" x="218" y="104" width="88" height="44" rx="3"/>' +
'<g transform="translate(110 108)">' +
 '<circle r="20" class="pl-bisu"/>' +
 '<circle r="20" fill="none" stroke="#8A6E42" stroke-width="1.4"/>' +
 '<text y="-1" text-anchor="middle" font-size="8" letter-spacing="1" fill="#FFF" font-family="serif">BI-SU</text>' +
 '<text y="9" text-anchor="middle" font-size="5" fill="#FFF7E6">COUNTER</text>' +
'</g>' +
'<path class="pl-route" d="M252 130 C220 138 160 134 132 118"/>' +
'<text class="pl-txt" x="240" y="142" font-size="7">B2 エレベーターから</text>' +
'</svg>';

const PLAN_GION =
'<svg viewBox="0 0 340 200" xmlns="http://www.w3.org/2000/svg">' + PLAN_COMMON_STYLE +
'<rect width="340" height="200" fill="#FBF8F2"/>' +
'<text x="20" y="26" font-size="12" letter-spacing="3" fill="#A8895A" font-family="serif">京都 祇園 — 周辺図</text>' +
/* 四条通 */
'<rect x="20" y="48" width="300" height="20" fill="#EDE6D4"/>' +
'<text class="pl-txt" x="170" y="61" text-anchor="middle" font-size="8" letter-spacing="3">四条通</text>' +
/* 花見小路通 */
'<rect x="158" y="48" width="18" height="136" fill="#EDE6D4"/>' +
'<text class="pl-txt" x="167" y="130" font-size="8" letter-spacing="2" transform="rotate(-90 167 130)" text-anchor="middle">花見小路通</text>' +
/* 街区 */
'<rect class="pl-blk" x="34" y="80" width="110" height="44" rx="3"/>' +
'<rect class="pl-blk" x="34" y="134" width="110" height="44" rx="3"/>' +
'<rect class="pl-blk" x="190" y="80" width="116" height="28" rx="3"/>' +
'<rect class="pl-blk" x="190" y="146" width="116" height="32" rx="3"/>' +
'<text class="pl-txt" x="248" y="170" font-size="7" text-anchor="middle" letter-spacing="1">建仁寺方面 ↓</text>' +
/* BI-SU（祇園町南側） */
'<g transform="translate(238 124)">' +
 '<rect x="-34" y="-12" width="68" height="26" rx="4" class="pl-bisu"/>' +
 '<text y="0" text-anchor="middle" font-size="8.5" letter-spacing="1.5" fill="#FFF" font-family="serif">美巣</text>' +
 '<text y="10" text-anchor="middle" font-size="5" letter-spacing="1" fill="#FFF7E6">祇園町南側</text>' +
'</g>' +
'<g transform="translate(60 56)">' +
 '<circle r="7" fill="none" stroke="#8A6E42" stroke-width="1.4"/>' +
 '<text class="pl-txt" y="-12" text-anchor="middle" font-size="6.5">祇園四条駅方面</text>' +
'</g>' +
'<path class="pl-route" d="M82 58 C130 58 150 70 176 100 C196 122 200 124 204 124"/>' +
'</svg>';

const FLOORPLANS = { gsix: PLAN_GSIX, salone: PLAN_SALONE, isetan: PLAN_ISETAN, gion: PLAN_GION };
