param([string]$OutputVideo = "")
$ErrorActionPreference = 'Stop'
if (-not $OutputVideo) { $OutputVideo = Join-Path $PSScriptRoot ('renders/experiencia-analise-foto-3d-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.mp4') }
& (Join-Path $PSScriptRoot 'render-capture.ps1') -InputVideo (Join-Path $PSScriptRoot 'assets/analysis-photo-seekable.mp4') -CameraPlan (Join-Path $PSScriptRoot 'camera-plan.example.json') -OutputVideo $OutputVideo
