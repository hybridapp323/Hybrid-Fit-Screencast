param(
  [Parameter(Mandatory = $true)][string]$InputVideo,
  [string]$OutputVideo = "",
  [switch]$PrepareOnly
)
$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
$capturePath = (Resolve-Path -LiteralPath $InputVideo).Path
$probeText = & ffprobe -v error -show_streams -show_format -of json $capturePath
if ($LASTEXITCODE -ne 0) { throw 'Nao foi possivel ler a captura.' }
$probe = $probeText | ConvertFrom-Json
$videoStream = $probe.streams | Where-Object codec_type -eq 'video' | Select-Object -First 1
if (-not $videoStream) { throw 'O arquivo nao tem uma faixa de video.' }
$duration = [double]::Parse([string]$videoStream.duration, [Globalization.CultureInfo]::InvariantCulture)
if ($duration -le 0) { throw 'A captura precisa ter duracao maior que zero.' }
$durationText = $duration.ToString('0.######', [Globalization.CultureInfo]::InvariantCulture)
$captureHash = (Get-FileHash -LiteralPath $capturePath -Algorithm SHA256).Hash.ToLowerInvariant()
$extension = [IO.Path]::GetExtension($capturePath).ToLowerInvariant()
if ($extension -notin '.mp4','.mov','.m4v','.webm') { throw 'Use uma captura MP4, MOV, M4V ou WebM.' }
$assetName = 'capture-' + $captureHash.Substring(0, 12) + $extension
$assetPath = Join-Path $projectRoot ('assets/' + $assetName)
if (-not (Test-Path -LiteralPath $assetPath)) { Copy-Item -LiteralPath $capturePath -Destination $assetPath }
$compositionPath = Join-Path $projectRoot 'index.html'
$composition = Get-Content -LiteralPath $compositionPath -Raw
$composition = [regex]::Replace($composition, 'data-duration="[0-9.]+"', ('data-duration="' + $durationText + '"'))
$composition = [regex]::Replace($composition, '(<video\b[^>]*\bsrc=")[^"]+', ('$1assets/' + $assetName))
[IO.File]::WriteAllText($compositionPath, $composition, [Text.UTF8Encoding]::new($false))
$sourceRatio = [double]$videoStream.width / [double]$videoStream.height
if ([Math]::Abs($sourceRatio - (480.0 / 1040.0)) -gt 0.005) {
  Write-Warning 'Esta captura tem outra proporcao. A tela preserva a imagem integral com margens; confira o enquadramento.'
}
$manifest = [ordered]@{
  source = $capturePath; sha256 = $captureHash; asset = 'assets/' + $assetName
  width = $videoStream.width; height = $videoStream.height; duration = $duration
  output = @{ width = 1080; height = 1920; fps = 30; audio = $false }
  layout = 'Hybrid Fit Stories 01'; sourcePreserved = $true
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $projectRoot 'capture.json') -Encoding utf8
if ($PrepareOnly) { Write-Output 'Captura preparada. Composicao pronta para revisar.'; return }
if (-not $OutputVideo) {
  $OutputVideo = Join-Path $projectRoot ('renders/hybrid-fit-stories-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.mp4')
} else { $OutputVideo = [IO.Path]::GetFullPath($OutputVideo) }
if (Test-Path -LiteralPath $OutputVideo) { throw 'O destino ja existe. Escolha outro nome para preservar o video anterior.' }
$outputParent = Split-Path -Parent $OutputVideo
New-Item -ItemType Directory -Force -Path $outputParent | Out-Null
Push-Location $projectRoot
try {
  & npm.cmd run check
  if ($LASTEXITCODE -ne 0) { throw 'A verificacao da composicao falhou.' }
  & npm.cmd run render -- --fps 30 --quality delivery --output $OutputVideo
  if ($LASTEXITCODE -ne 0) { throw 'A exportacao falhou.' }
  & ffprobe -v error -show_entries stream=codec_name,width,height,r_frame_rate:format=duration,size -of json $OutputVideo
  if ($LASTEXITCODE -ne 0) { throw 'Nao foi possivel verificar o MP4 exportado.' }
  Write-Output ('Video salvo: ' + $OutputVideo)
} finally { Pop-Location }
