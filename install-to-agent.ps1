<#
.SYNOPSIS
  Install the HyperFrames skill kit into an agent on Windows.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 opencode
  powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 claude
  powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 agents
  powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 project
#>
param(
  [ValidateSet("opencode", "claude", "agents", "project")]
  [string]$Target = "opencode"
)

$Kit = Join-Path $PSScriptRoot "skills"

switch ($Target) {
  "opencode" { $Dest = Join-Path $env:USERPROFILE ".config\opencode\skills" }
  "claude"   { $Dest = Join-Path $env:USERPROFILE ".claude\skills" }
  "agents"   { $Dest = Join-Path $env:USERPROFILE ".agents\skills" }
  "project"  { $Dest = Join-Path (Get-Location) ".opencode\skills" }
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
$count = 0

function Copy-SkillDir($src, $destRoot) {
  if (-not (Test-Path (Join-Path $src "SKILL.md"))) { return }
  $name = Split-Path $src -Leaf
  $dest = Join-Path $destRoot $name
  if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
  Copy-Item $src $dest -Recurse -Force
  $script:count++
}

Get-ChildItem $Kit -Directory | ForEach-Object { Copy-SkillDir $_.FullName $Dest }

# nested registry blocks (hf-blocks\<name>\SKILL.md -> skill id = <name>)
$blocks = Join-Path $Kit "hf-blocks"
if (Test-Path $blocks) {
  $blocksDest = Join-Path $Dest "hf-blocks"
  New-Item -ItemType Directory -Force -Path $blocksDest | Out-Null
  Get-ChildItem $blocks -Directory | ForEach-Object { Copy-SkillDir $_.FullName $blocksDest }
}

Write-Host "installed $count skills into $Dest"
