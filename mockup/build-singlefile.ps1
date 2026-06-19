# ============================================================
# BI-SU 会員アプリ モックアップ: src/ を1枚のHTMLにまとめる
# 出力: mockup/bisu-app-mockup.html（CSS/JS/画像をすべて埋め込み）
# 実行: powershell -ExecutionPolicy Bypass -File build-singlefile.ps1
# ============================================================
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root 'src'
$out  = Join-Path $root 'bisu-app-mockup.html'

$html = [IO.File]::ReadAllText((Join-Path $src 'index.html'))

# --- CSSをインライン化 ---
$css  = [IO.File]::ReadAllText((Join-Path $src 'styles.css'))
$html = $html.Replace('<link rel="stylesheet" href="styles.css">', "<style>`n$css`n</style>")

# --- JSをインライン化 ---
foreach ($js in @('assets/qrcode.js', 'assets/three.min.js', 'scenes.js', 'logo3d.js', 'app.js')) {
  $path = Join-Path $src ($js -replace '/', '\')
  $code = [IO.File]::ReadAllText($path)
  $tag  = '<script src="' + $js + '"></script>'
  $html = $html.Replace($tag, "<script>`n$code`n</script>")
}

# --- 画像・動画をdata URIに変換 ---
$eval = {
  param($m)
  $rel  = $m.Groups[1].Value
  $file = Join-Path $src ('assets\' + $rel)
  if (-not (Test-Path $file)) { return $m.Value }
  $mime = 'image/jpeg'
  if ($rel -match '\.png$') { $mime = 'image/png' }
  if ($rel -match '\.mp4$') { $mime = 'video/mp4' }
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file))
  return "data:$mime;base64,$b64"
}
$html = [regex]::Replace($html, 'assets/([A-Za-z0-9_\-\.]+\.(?:jpg|png|mp4))', $eval)

[IO.File]::WriteAllText($out, $html, (New-Object System.Text.UTF8Encoding($false)))
$kb = [math]::Round((Get-Item $out).Length / 1KB)
$left = ([regex]::Matches($html, 'assets/')).Count
Write-Host "OK: $out (${kb}KB) / 未解決のassets参照: $left"
