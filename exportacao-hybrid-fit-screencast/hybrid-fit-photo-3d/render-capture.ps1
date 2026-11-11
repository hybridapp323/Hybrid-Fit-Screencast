param(
  [Parameter(Mandatory = $true)][string]$InputVideo,
  [Parameter(Mandatory = $true)][string]$CameraPlan,
  [string]$OutputVideo = '',
  [switch]$PrepareOnly
)
$ErrorActionPreference = 'Stop'
if (-not $PrepareOnly) {
  if (-not $OutputVideo) { $OutputVideo = Join-Path $PSScriptRoot ('renders/hybrid-fit-stories-3d-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.mp4') }
  $OutputVideo = [IO.Path]::GetFullPath($OutputVideo)
  if (Test-Path -LiteralPath $OutputVideo) { throw 'A saida ja existe; escolha outro nome.' }
}
$capturePath = (Resolve-Path -LiteralPath $InputVideo).Path
$planPath = (Resolve-Path -LiteralPath $CameraPlan).Path
& node (Join-Path $PSScriptRoot 'prepare-capture.cjs') $capturePath $planPath
if ($LASTEXITCODE -ne 0) { throw 'A preparacao da captura/plano falhou.' }
if ($PrepareOnly) { return }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputVideo) | Out-Null
Push-Location $PSScriptRoot
try {
  & npm.cmd run check
  if ($LASTEXITCODE -ne 0) { throw 'A verificacao da composicao falhou.' }
  & npm.cmd run render -- --fps 30 --quality delivery --output $OutputVideo
  if ($LASTEXITCODE -ne 0) { throw 'A exportacao falhou.' }
  & ffmpeg -v error -i $OutputVideo -f null NUL
  if ($LASTEXITCODE -ne 0) { throw 'Falha de decodificacao do MP4 exportado.' }
  $probe = (& ffprobe -v error -show_streams -show_format -of json $OutputVideo) | ConvertFrom-Json
  if ($LASTEXITCODE -ne 0) { throw 'Nao foi possivel verificar o MP4.' }
  $video = $probe.streams | Where-Object codec_type -eq 'video' | Select-Object -First 1
  $manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'capture.json') -Raw | ConvertFrom-Json
  $seconds = [double]::Parse([string]$video.duration, [Globalization.CultureInfo]::InvariantCulture)
  if (-not $video -or $video.width -ne 1080 -or $video.height -ne 1920 -or $video.r_frame_rate -ne '30/1' -or ($probe.streams | Where-Object codec_type -eq 'audio') -or [Math]::Abs($seconds - $manifest.duration) -gt (1.0/30.0 + 0.001)) {
    throw 'O MP4 nao corresponde ao formato/duracao aprovados.'
  }
  Write-Output ('Video salvo: ' + $OutputVideo)
} finally { Pop-Location }
