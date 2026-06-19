/* ============================================================
   BI-SUエンブレム 3D表示モジュール（Three.js）
   - 形状: 公式エンブレムの正確なベクター（glass-clear.svg 由来。
     円環=外周+内周の穴あきシェイプ / ツバメ=交差する尾を含む本物の形）
   - 質感: クリアガラス（transmission）＋ 環境マップ反射
   - ランクカラーはガラスのティント（attenuation）と後光で表現
   - WebGL不可環境では init() が false → フラットSVGにフォールバック
   ============================================================ */

window.LOGO3D = (function(){

  /* 公式エンブレムのアウトライン（glass-clear.svg の path d をそのまま使用。
     subpath構成: [0]=円環の外周 / [1]=円環の内周(穴) / [2]=ツバメ本体 */
  const EMBLEM_D =
    'M517 0L564 0L625 6L678 17L723 31L767 49L818 76L856 101L880 121L882 121L886 126L888 126L901 139L903 139L941 177L941 179L949 186L949 188L954 192L954 194L959 198L959 200L979 224L1010 272L1033 317L1050 359L1067 417L1074 453L1080 508L1080 572L1077 606L1067 663L1050 721L1033 763L1010 808L979 856L959 880L959 882L949 892L949 894L941 901L941 903L903 941L901 941L888 954L886 954L882 959L880 959L856 979L818 1004L767 1031L723 1049L666 1066L611 1076L564 1080L517 1080L456 1074L403 1063L355 1048L316 1032L258 1001L218 974L190 950L188 950L181 942L179 942L138 901L138 899L125 886L125 884L101 855L72 810L51 770L29 716L17 676L6 622L1 575L0 529L5 465L15 412L28 367L46 321L72 270L101 225L125 196L125 194L138 181L138 179L179 138L181 138L188 130L190 130L218 106L268 73L316 48L355 32L415 14L470 4Z' +
    'M510 56L571 56L610 60L652 68L700 82L740 98L788 123L823 146L842 162L844 162L848 167L850 167L854 172L856 172L888 202L888 204L914 231L914 233L937 261L969 313L990 358L1006 404L1017 450L1024 503L1025 561L1022 598L1015 640L1002 689L984 736L963 778L937 819L914 847L914 849L909 853L909 855L878 888L876 888L864 901L862 901L839 922L801 949L775 963L774 965L762 970L761 972L719 991L668 1008L623 1018L572 1024L534 1025L478 1021L433 1013L378 997L332 978L298 960L255 932L235 915L233 915L229 910L227 910L221 903L219 903L187 872L187 870L177 861L177 859L154 833L126 792L105 754L86 710L70 659L61 615L56 568L56 512L60 472L69 425L82 381L98 341L120 298L148 255L166 234L166 232L171 228L171 226L177 221L177 219L208 187L210 187L219 177L221 177L247 154L283 129L330 103L378 83L417 71L471 60Z' +
    'M531 111L533 111L540 127L551 145L598 238L600 238L616 223L636 213L654 209L675 209L696 214L710 221L720 228L733 241L741 253L749 272L751 284L914 794L913 796L910 793L910 791L875 751L871 744L866 740L866 738L861 734L861 732L856 728L856 726L816 680L812 673L807 669L807 667L802 663L802 661L762 615L758 608L753 604L753 602L748 598L748 596L743 592L743 590L708 550L704 543L699 539L699 537L694 533L694 531L689 527L689 525L684 521L684 519L679 515L679 513L674 509L674 507L654 485L650 478L621 445L596 552L545 789L546 809L574 1010L532 845L529 849L490 1008L519 790L443 445L437 450L437 452L412 480L408 487L403 491L403 493L398 497L398 499L368 533L364 540L359 544L359 546L354 550L354 552L349 556L349 558L344 562L344 564L319 592L315 599L310 603L310 605L305 609L305 611L300 615L300 617L275 645L271 652L266 656L266 658L261 662L261 664L256 668L256 670L251 674L251 676L231 698L227 705L222 709L222 711L217 715L217 717L212 721L212 723L207 727L207 729L202 733L202 735L197 739L183 758L150 796L321 256L335 236L349 224L368 214L389 209L410 209L433 215L452 226L465 239Z';

  const SCALE = 9.2 / 540;   /* エンブレム半径540 → ワールド9.2 */
  function tx(x){ return (x - 540) * SCALE; }
  function ty(y){ return (540 - y) * SCALE; }

  /* M/L/Z（絶対座標）のみのパスをサブパス（点列）に分解 */
  function parseContours(d){
    const tk = d.replace(/([A-Za-z])/g, ' $1 ').replace(/,/g, ' ').split(/\s+/).filter(Boolean);
    const contours = [];
    let cur = null, i = 0;
    while (i < tk.length){
      const t = tk[i];
      if (/^[A-Za-z]$/.test(t)){
        if (t === 'M'){ cur = []; contours.push(cur); }
        i++;
        continue;
      }
      const x = parseFloat(tk[i++]);
      const y = parseFloat(tk[i++]);
      cur.push(new THREE.Vector2(tx(x), ty(y)));
    }
    return contours;
  }

  /* ガラス反射用の簡易環境マップ（キャンバス製エクイレクト） */
  function makeEnvironment(renderer){
    const c = document.createElement('canvas');
    c.width = 256; c.height = 128;
    const g = c.getContext('2d');
    const gr = g.createLinearGradient(0, 0, 0, 128);
    gr.addColorStop(0, '#E8ECF2');
    gr.addColorStop(.45, '#9AA3B2');
    gr.addColorStop(.55, '#5C636E');
    gr.addColorStop(1, '#1E2126');
    g.fillStyle = gr;
    g.fillRect(0, 0, 256, 128);
    /* 窓明かり風のハイライト（ガラスの面に映る） */
    g.fillStyle = 'rgba(255,255,255,.95)'; g.fillRect(28, 16, 64, 11);
    g.fillStyle = 'rgba(255,255,255,.7)';  g.fillRect(150, 28, 84, 9);
    g.fillStyle = 'rgba(255,244,214,.5)';  g.fillRect(96, 68, 72, 7);
    const tex = new THREE.CanvasTexture(c);
    tex.mapping = THREE.EquirectangularReflectionMapping;
    tex.colorSpace = THREE.SRGBColorSpace;
    const pmrem = new THREE.PMREMGenerator(renderer);
    const env = pmrem.fromEquirectangular(tex).texture;
    pmrem.dispose();
    tex.dispose();
    return env;
  }

  let renderer = null, scene, camera, group, glassMat, glow, key, rim, sweep, raf = null, t0 = 0;

  function build(container){
    if (!window.THREE) return false;
    try {
      /* preserveDrawingBuffer: 画面キャプチャ／スクリーンショットを可能にする（小canvasのため負荷影響は無視できる） */
      renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true, powerPreference: 'low-power', preserveDrawingBuffer: true });
    } catch (e) { return false; }
    const W = container.clientWidth || 200, H = container.clientHeight || 158;
    renderer.setSize(W, H);
    renderer.setPixelRatio(Math.min(2, window.devicePixelRatio || 1));
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.15;
    container.innerHTML = '';
    container.appendChild(renderer.domElement);

    scene = new THREE.Scene();
    scene.environment = makeEnvironment(renderer);
    camera = new THREE.PerspectiveCamera(34, W / H, .1, 100);
    camera.position.set(0, 0, 30);

    scene.add(new THREE.AmbientLight(0xFFFFFF, .4));
    key = new THREE.DirectionalLight(0xFFFFFF, .9); key.position.set(6, 8, 11); scene.add(key);
    rim = new THREE.DirectionalLight(0xBCD8FF, .4); rim.position.set(-7, -4, -6); scene.add(rim);
    /* 表面をなめる“光のスイープ”用。横切る瞬間だけ強く光らせて高級感を出す */
    sweep = new THREE.DirectionalLight(0xFFF1D6, 0); sweep.position.set(0, 4, 11); scene.add(sweep);

    group = new THREE.Group();
    /* マークは静止。やや見上げる固定アングルで立体感だけ残す */
    group.rotation.set(.05, -.16, 0);
    scene.add(group);

    /* 後光（ランク色・明滅） */
    const gc = document.createElement('canvas');
    gc.width = gc.height = 128;
    const gg = gc.getContext('2d');
    const grad = gg.createRadialGradient(64, 64, 4, 64, 64, 62);
    grad.addColorStop(0, 'rgba(255,255,255,.85)');
    grad.addColorStop(.4, 'rgba(255,255,255,.28)');
    grad.addColorStop(1, 'rgba(255,255,255,0)');
    gg.fillStyle = grad;
    gg.fillRect(0, 0, 128, 128);
    glow = new THREE.Sprite(new THREE.SpriteMaterial({
      map: new THREE.CanvasTexture(gc), color: 0xC9A24B, transparent: true,
      opacity: .3, depthWrite: false, blending: THREE.AdditiveBlending
    }));
    glow.scale.set(24, 24, 1);
    glow.position.z = -4;
    group.add(glow);

    /* 公式エンブレム形状の構築 */
    const ct = parseContours(EMBLEM_D);   /* [0]=外周 [1]=内周(穴) [2]=ツバメ */
    const ringShape = new THREE.Shape(ct[0]);
    const holePath = new THREE.Path(ct[1]);
    ringShape.holes = [holePath];
    const swallowShape = new THREE.Shape(ct[2]);

    /* クリアガラス材質（ランク色はattenuationでティント） */
    glassMat = new THREE.MeshPhysicalMaterial({
      color: 0xFFFFFF, metalness: 0, roughness: .07,
      transmission: 1, thickness: 2.4, ior: 1.5,
      clearcoat: 1, clearcoatRoughness: .06,
      attenuationColor: new THREE.Color(0xC9A24B), attenuationDistance: 6,
      envMapIntensity: 1.2, specularIntensity: 1,
      transparent: true, side: THREE.DoubleSide
    });

    const ringGeo = new THREE.ExtrudeGeometry(ringShape, {
      depth: 1.1, bevelEnabled: true, bevelThickness: .16, bevelSize: .14, bevelSegments: 2, curveSegments: 12
    });
    ringGeo.translate(0, 0, -.55);
    group.add(new THREE.Mesh(ringGeo, glassMat));

    const swGeo = new THREE.ExtrudeGeometry(swallowShape, {
      depth: 1.6, bevelEnabled: true, bevelThickness: .18, bevelSize: .16, bevelSegments: 2, curveSegments: 12
    });
    swGeo.translate(0, 0, -.8);
    group.add(new THREE.Mesh(swGeo, glassMat));

    /* 全体を10%縮小（上下の見切れ防止＋やや小さく） */
    group.scale.setScalar(.9);

    return true;
  }

  function tick(now){
    raf = requestAnimationFrame(tick);
    const t = (now - t0) / 1000;

    /* マークは動かさない。ライティングの角度だけを動かして光を流す。 */

    /* キーライト: 左右にゆっくり振れ、ガラス面のハイライトを移動させる */
    const a = t * .42;
    key.position.set(Math.sin(a) * 11, 7 + Math.sin(a * 1.3) * 2.5, 11);
    key.intensity = .82 + (Math.cos(a) * .5 + .5) * .3;

    /* リムライト: 逆位相で縁の光り方を変える */
    rim.position.set(-Math.sin(a) * 9, -3 + Math.sin(a * .9) * 2, -6);

    /* 光のスイープ: 約6秒ごとに左→右へ一条の光が表面を横切る */
    const phase = (t % 6) / 6;                            /* 0→1 */
    const bell = Math.pow(Math.sin(phase * Math.PI), 3);  /* 中央でピークの釣鐘 */
    sweep.position.set((phase - .5) * 26, 5, 11);
    sweep.intensity = bell * 2.2;

    /* スイープ通過時はガラス面の映り込みも強め、面全体が“照る”ようにする */
    glassMat.envMapIntensity = 1.2 + bell * .5;

    /* 後光はスイープに連動してわずかに息づく（明滅しすぎない） */
    glow.material.opacity = .22 + bell * .14;

    renderer.render(scene, camera);
  }

  return {
    init: function(container){
      try { return build(container); } catch (e) { return false; }
    },
    start: function(){
      if (renderer && raf === null){ t0 = performance.now(); raf = requestAnimationFrame(tick); }
    },
    stop: function(){
      if (raf !== null){ cancelAnimationFrame(raf); raf = null; }
    },
    setColor: function(hex, softHex){
      if (!glassMat) return;
      glassMat.attenuationColor.set(hex);            /* ガラスの色味（厚み部分に乗る） */
      glassMat.color.set(0xFFFFFF).lerp(new THREE.Color(softHex || hex), .18);  /* ごく薄い表面ティント */
      glow.material.color.set(hex);                  /* 後光はランク色 */
    }
  };
})();
