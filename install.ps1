# autopilot installer (Windows PowerShell) — harness-aware, verifying, idempotent.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
param(
  [ValidateSet('auto','claude','codex','cursor','opencode','zcode','all')][string]$Harness = 'auto',
  [string]$Dir = '',
  [switch]$Slim,
  [switch]$WithUpstream,  # legacy alias: full install is the default
  [string]$Logbook = '',
  [switch]$NoLogbook,
  [switch]$DryRun,
  [switch]$Uninstall,
  [switch]$Yes
)
$ErrorActionPreference = 'Stop'
# Usage:
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1)))
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/autopilot-skill/main/install.ps1))) -Harness zcode -DryRun

$PubUrl = 'https://github.com/zkkk9555/autopilot-skill'
$UpstreamUrl = 'https://github.com/mattpocock/skills'
$UpstreamNames = @('ask-matt','code-review','codebase-design','diagnosing-bugs','domain-modeling','grill-me','grill-with-docs','grilling','handoff','implement','improve-codebase-architecture','prototype','research','resolving-merge-conflicts','setup-matt-pocock-skills','tdd','teach','to-questionnaire','to-spec','to-tickets','triage','wait-what','wayfinder','wizard','writing-for-agents')

function Harness-Dir($h) {
  switch ($h) {
    'claude' { return (Join-Path $HOME '.claude\skills') }
    'codex' { return (Join-Path $HOME '.codex\skills') }
    'cursor' { return (Join-Path $HOME '.cursor\skills') }
    'opencode' { return (Join-Path $HOME '.config\opencode\skills') }
    'zcode' { return (Join-Path $HOME '.zcode\skills') }
  }
  return ''
}
function Detect-Harness {
  $f = @()
  if ($env:CLAUDECODE -or $env:CLAUDE_CODE_ENTRYPOINT) { $f += 'claude' }
  if ($env:CODEX_HOME -or $env:CODEX_THREAD_ID) { $f += 'codex' }
  if ($env:CURSOR_AGENT -or $env:CURSOR_TRACE_ID) { $f += 'cursor' }
  if ($env:OPENCODE_CLIENT) { $f += 'opencode' }
  if ($env:ZCODE_APP_VERSION -or $env:ZCODE_SESSION_ID) { $f += 'zcode' }
  if ($f.Count -eq 1) { return $f[0] } else { return '' }
}

$Targets = @((Join-Path $HOME '.agents\skills'))
if ($env:AUTOPILOT_SKILLS_DIR -and -not $Dir) { $Dir = $env:AUTOPILOT_SKILLS_DIR }
if ($Dir) { $Targets = @($Dir) }
elseif ($Harness -eq 'all') { $Targets += @('claude','codex','cursor','opencode','zcode' | ForEach-Object { Harness-Dir $_ }) }
elseif ($Harness -ne 'auto') { $d = Harness-Dir $Harness; if ($d -and ($Targets -notcontains $d)) { $Targets += $d } }
else { $det = Detect-Harness; if ($det) { $d = Harness-Dir $det; if ($Targets -notcontains $d) { $Targets += $d } } }

$Want = @('autopilot'); if (-not $Slim) { $Want += $UpstreamNames }

if ($DryRun) {
  Write-Host "plan: targets: $($Targets -join ', ')"; Write-Host "plan: skills: $($Want -join ' ')"
  Write-Host "plan: logbook: $(if ($NoLogbook) { 'skipped' } else { if ($Logbook) { $Logbook } elseif ($env:AUTOPILOT_LOGBOOK) { $env:AUTOPILOT_LOGBOOK } else { Join-Path $HOME '.autopilot\USAGE-LOG.md' } })"
  return
}
if ($Uninstall) {
  if ($Targets.Count -ge 2 -and -not $Yes) { Write-Host 'refusing: 2+ targets without -Yes'; return }
  foreach ($t in $Targets) {
    if ($t -in @('/', $HOME, 'C:\')) { Write-Host "refusing dangerous target: $t"; return }
    foreach ($n in (@('autopilot') + $UpstreamNames)) { $p = Join-Path $t $n; if (Test-Path $p) { Remove-Item -Recurse -Force $p; Write-Host "removed $p" } }
  }
  Write-Host 'kept logbook (uninstall never deletes it)'; return
}

$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('autopilot-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
try {
  Write-Host '==> Downloading autopilot'
  $retry = 0; $ok = $false
  while (-not $ok -and $retry -lt 3) { try { Invoke-WebRequest "$PubUrl/archive/refs/heads/main.tar.gz" -OutFile "$Tmp\pub.tar.gz"; $ok = $true } catch { $retry++; if ($retry -ge 3) { throw } } }
  tar -xzf "$Tmp\pub.tar.gz" -C $Tmp
  if (-not (Test-Path "$Tmp\autopilot-skill-main\autopilot\SKILL.md")) { throw 'driver payload broken' }
  if (-not $Slim) {
    Write-Host '==> Downloading upstream 25 workflow skills'
    $retry = 0; $ok = $false
    while (-not $ok -and $retry -lt 3) { try { Invoke-WebRequest "$UpstreamUrl/archive/refs/heads/main.tar.gz" -OutFile "$Tmp\up.tar.gz"; $ok = $true } catch { $retry++; if ($retry -ge 3) { throw } } }
    tar -xzf "$Tmp\up.tar.gz" -C $Tmp --exclude='skills-main/AGENTS.md'
    if ($LASTEXITCODE -ne 0) { Write-Host '!! extract warnings, continuing + verifying below' }
  }
  $fail = $false
  foreach ($t in $Targets) {
    New-Item -ItemType Directory -Force -Path $t | Out-Null
    if (Test-Path "$t\autopilot") { Remove-Item -Recurse -Force "$t\autopilot" }
    Copy-Item -Recurse -Force "$Tmp\autopilot-skill-main\autopilot" "$t\autopilot"
    if (-not $Slim) {
      Get-ChildItem "$Tmp\skills-main\skills" -Directory | ForEach-Object {
        Get-ChildItem $_.FullName -Directory | ForEach-Object {
          if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
            $target = Join-Path $t $_.Name
            if (Test-Path $target) { Remove-Item -Recurse -Force $target }
            Copy-Item -Recurse -Force $_.FullName $target
          }
        }
      }
    }
    $head = Get-Content "$t\autopilot\SKILL.md" -TotalCount 5 -Raw
    if ($head -notmatch '(?m)^name: autopilot') { Write-Host "ERROR: $t\autopilot\SKILL.md frontmatter wrong"; $fail = $true }
    $have = 0; $miss = @()
    foreach ($n in $Want) { if (Test-Path "$t\$n\SKILL.md") { $have++ } else { $miss += $n } }
    if ($have -eq $Want.Count) { Write-Host "OK ${t}: autopilot + upstream ($have/$($Want.Count) SKILL.md)" }
    else { Write-Host "WARNING ${t}: only $have/$($Want.Count) (missing: $($miss -join ',')) — rerun full install" }
  }
  if (-not $NoLogbook) {
    $Lb = if ($Logbook) { $Logbook } elseif ($env:AUTOPILOT_LOGBOOK) { $env:AUTOPILOT_LOGBOOK } else { Join-Path $HOME '.autopilot\USAGE-LOG.md' }
    if (-not (Test-Path $Lb)) {
      New-Item -ItemType Directory -Force -Path (Split-Path $Lb) | Out-Null
      Set-Content -Path $Lb -Value "# autopilot 中央使用日志`r`n`r`n> 本本由安装脚本创建。规则：只追加、不改旧条；每次任务收尾追加一条；升级打水位线。格式见 USAGE-LOG.example.md。`r`n" -Encoding UTF8
      Write-Host "==> Logbook created -> $Lb"
    } else { Write-Host "==> Logbook kept -> $Lb" }
  }
  Write-Host ''; Write-Host '==> Done. Restart your agent and check the skill list shows autopilot,'
  Write-Host '    then say: "The sidebar toggle stopped working - check and fix it."'
  if ($fail) { throw 'verification failed' }
} finally {
  Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
