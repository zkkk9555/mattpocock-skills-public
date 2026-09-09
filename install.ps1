# autopilot installer (Windows PowerShell)
# Copies this driver skill (and optionally the 25 upstream workflow skills)
# into your agent skills directory.
# Usage:
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1)))
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1))) -WithUpstream
# Env override: $env:MATTP_SKILLS_DIR = "D:\your\skills\dir"
param([switch]$WithUpstream)
$ErrorActionPreference = "Stop"

$PubUrl = "https://github.com/zkkk9555/autopilot-skill"
$UpstreamUrl = "https://github.com/mattpocock/skills"
$Dest = if ($env:MATTP_SKILLS_DIR) { $env:MATTP_SKILLS_DIR } else { Join-Path $HOME ".agents\skills" }

Write-Host "==> Target skills dir: $Dest"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null

$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("mattp-" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
try {
  Write-Host "==> Downloading autopilot"
  Invoke-WebRequest "$PubUrl/archive/refs/heads/main.tar.gz" -OutFile "$Tmp\pub.tar.gz"
  tar -xzf "$Tmp\pub.tar.gz" -C $Tmp
  $Src = Join-Path $Tmp "autopilot-skill-mainutopilot"
  if (Test-Path "$Destutopilot") { Remove-Item -Recurse -Force "$Destutopilot" }
  Copy-Item -Recurse -Force $Src "$Destutopilot"
  Write-Host "    installed -> $Destutopilot"

  if ($WithUpstream) {
    Write-Host "==> Downloading upstream 25 workflow skills"
    Invoke-WebRequest "$UpstreamUrl/archive/refs/heads/main.tar.gz" -OutFile "$Tmp\up.tar.gz"
    tar -xzf "$Tmp\up.tar.gz" -C $Tmp
    $count = 0
    Get-ChildItem (Join-Path $Tmp "skills-main") -Directory | ForEach-Object {
      if (Test-Path (Join-Path $_.FullName "SKILL.md")) {
        $target = Join-Path $Dest $_.Name
        if (Test-Path $target) { Remove-Item -Recurse -Force $target }
        Copy-Item -Recurse -Force $_.FullName $target
        $count++
      }
    }
    Write-Host "    installed $count upstream skills -> $Dest"
  } else {
    Write-Host ""
    Write-Host "!! Upstream skills are NOT installed yet. The driver drives the 25 workflow"
    Write-Host "   skills from $UpstreamUrl - without them it falls back to built-in"
    Write-Host "   speed notes (functional, but weaker). Install with:"
    Write-Host '   & ([scriptblock]::Create((irm <this installer URL>))) -WithUpstream'
    Write-Host ""
  }
  Write-Host "==> Done. Restart your agent, then say one sentence, e.g.:"
  Write-Host '    "The sidebar toggle stopped working - check and fix it."'
  # Central logbook: create the first book so the driver can append from day one.
  $Logbook = if ($env:MATTP_LOGBOOK) { $env:MATTP_LOGBOOK } else { Join-Path $HOME ".autopilot\USAGE-LOG.md" }
  if (-not (Test-Path $Logbook)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $Logbook) | Out-Null
    $head = "# autopilot 中央使用日志`r`n`r`n> 本本由安装脚本创建（$((Get-Date).ToUniversalTime().ToString('yyyy-MM-dd'))）。规则：只追加、不改旧条；每次任务收尾追加一条；升级打水位线。格式见 USAGE-LOG.example.md。`r`n"
    Set-Content -Path $Logbook -Value $head -Encoding UTF8
    Write-Host "==> Logbook created -> $Logbook"
  } else {
    Write-Host "==> Logbook already exists -> $Logbook (kept)"
  }
} finally {
  Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
