# bisu_app — BI-SU 会員アプリ（Flutter）

BI-SU 会員向けアプリ v2.1 HTMLモックアップ（`../mockup/`）を **Flutter へ忠実移植**したプロジェクトです。
設計の地図は `../docs/09_Flutter化計画.md`。本READMEは実行手順・構成・忠実度・既知事項をまとめます。

- 対象: iOS / Android / **Web**（まずは `flutter run -d chrome` で動作確認）
- 状態: **Webビルド成功・実機Web描画を確認済み**（全5タブ＋会員証モーダル）。データは閲覧専用ダミー（`lib/data/mock_data.dart`）。
- **AI機能は対象外**（AIコンシェルジュ/Lambda/RAG は MIRANEST アプリ側。本アプリには含めない）。

---

## 前提（このマシンでの実行）

Flutter SDK は **`C:\src\flutter`** に導入済み（グローバルPATHには未登録）。各コマンドの前にPATHを通します。

```bash
# Git Bash の場合
export PATH="/c/src/flutter/bin:$PATH"
flutter --version   # 3.44.4 / Dart 3.12.2
```

```powershell
# PowerShell の場合
$env:PATH = "C:\src\flutter\bin;$env:PATH"
flutter --version
```

Web（Chrome）は利用可能。Android/iOS 実機ビルドには別途 Android SDK / Xcode が必要（未導入）。

---

## 実行方法

```bash
cd "C:/Users/y-has/Desktop/claude-test/projects/BI-SU APP/bisu_app"
export PATH="/c/src/flutter/bin:$PATH"

flutter pub get
flutter run -d chrome          # ローカルWebで起動（最優先の動作確認）
# もしくは静的ビルド
flutter build web              # build/web/ に出力
```

### Widgetbook（UIカタログ）

```bash
flutter run -t lib/widgetbook/main.dart -d chrome
```

主要な共有Widget（BisuChip / GlassCard / RankEmblem 全5ランク / BisuButton / BisuTextField / CodeInput / ToggleSwitch / SettingRow / SubscriptionCard / OrderCard / ProfileCard / ConfirmDialog）をカタログ化。ランク切替・テーマのaddon付き。

---

## プロジェクト構成

```
lib/
├── main.dart / app.dart          # エントリ・MaterialApp・AppScope・SplashScreen→RootScaffold
├── root_scaffold.dart            # 5タブ（IndexedStack + BisuTabBar）
├── state/app_state.dart          # AppState(ChangeNotifier): rank / loggedIn + 計算getter, AppScope(InheritedNotifier)
├── theme/                        # bisu_colors / bisu_typography / bisu_theme / rank_palette
├── models/                       # Rank / Member / Subscription / Order / Store（immutable）
├── data/mock_data.dart           # RANKS/MEMBER/STORE_POINTS/SUBSCRIPTIONS/ORDERS/STORES（app.js由来のダミー）
├── shared/                       # swallow_svg / format(yen) / widgets/*（再利用部品）
├── features/                     # 画面（home, subscription, history, stores, settings, auth, splash, membership_card, extras）
├── screens/                      # features/ への再エクスポートshim（contractの画面名で参照可能に）
└── widgetbook/main.dart          # Widgetbook別エントリ
assets/
├── images/   logo, 商品(p_*.jpg), 店舗(s_*.jpg)
└── videos/   起動演出 journey-*.mp4 ×5
doc/screenshots/                  # 実機Web描画のスクショ（モック整合の証跡）
```

### 状態管理
最小構成：`AppState extends ChangeNotifier` を `AppScope`(InheritedNotifier) で配布。`rank`（既定 member）と `loggedIn`（既定 true＝モック初期状態）を保持し、ポイント・進捗%・進捗ラベル・店舗ポイントを計算getterで提供。外部状態管理パッケージは未使用。

---

## ハイブリッド方式（会員 / 未ログイン）
`AppState.loggedIn` で切替。未ログインでも 仮会員証・店舗ポイント・店舗一覧・設定（基本）・言語・ブランドストーリーが利用可。会員のみ ステータス・定期情報・購入履歴・通知設定 が解放（モック `setLoggedIn` 準拠）。

---

## 忠実度メモ（モックからの意図的な簡略化）

| 項目 | 対応 |
|---|---|
| 起動演出の最終フレーム→ホーム背景の引き継ぎ（`__videoHomeShot`） | **未再現**。動画再生→演出後にホームへ遷移（背景は色味グラデ＋エンブレム）。動画読込失敗時は約2.4秒でフォールバック遷移 |
| 3Dロゴエンブレム（Three.js） | フラットなSVGエンブレム（`flutter_svg`）に置換（計画§7の方針どおり） |
| ストアーズ（店舗一覧） | v2.1で **WebViewプレースホルダ**（ネイティブのリスト/マップ/詳細は廃止）。Flutter Webで描画できる `webview_flutter` は使わず、公式サイト店舗ページの表示イメージをネイティブ描画で再現 |
| フォント | 端末フォント＋fallback（Hiragino/Yu/Noto）。フォントバイナリ同梱はしていない（オフライン完全一致が必要なら Noto Serif/Sans JP を `assets/fonts/` に同梱） |
| バーコード | モックの `generateBarcodeSVG` ロジックを `CustomPainter` で再現（ダミー） |

---

## 検証状況

- `flutter analyze`: **本体エラー0**。残りは Widgetbook の `knobs.list` 非推奨 info ×3 のみ（動作影響なし）。
- `flutter build web`: **成功**（dart2js / Wasm dry run 通過）。
- 実機Web描画（Chrome 390×844）: ホーム(会員) / 定期情報 / 購入履歴 / ストアーズ / 設定 / 会員証モーダル を確認、**コンソールエラー0**。スクショは `doc/screenshots/`。

### 既知の軽微事項（今後の整理候補・動作影響なし）
- `lib/screens/` は `lib/features/` への再エクスポートshim層（命名contractのため）。将来は片寄せ可。
- `CoachMark`(SCR-006) が2ファイルに重複・未配線（dead code）。本配線時にどちらかへ統一。
- Widgetbook の `knobs.list` 非推奨 → `knobs.object.dropdown` へ置換余地。

---

## 対象外・次の一歩
- **データ層**: 現在は `mock_data.dart` の閲覧専用ダミー。本番は 楽楽認証＋Snowflake/楽楽EC API へ差し替え（ブロッカー OP-24/26/28 確定後）。
- **実機ビルド**: Android SDK / Xcode 導入後に android/ios を調整。
- **AI機能は実装しない**（MIRANEST アプリの領域）。
