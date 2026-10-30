# Instala <Nombre del proyecto> en Windows 10/11. Antes hay que haber hecho «Antes de empezar» de INSTALAR.md.
# Uso (doble clic o en una terminal):  windows\instalar.cmd          (plugin desde GitHub)
#                                      windows\instalar.cmd -Local   (plugin desde esta carpeta, para probar)
# Se puede repetir: lo que ya está hecho se salta.
param([switch]$Local)
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"   # sin barra de progreso, las descargas van mucho más rápido

# ---- AJUSTES (rellenar al crear el proyecto; los mismos que en mac/instalar.sh) ----
$Nombre = "<nombre-repo>"
$Tipo = "<app|plugin|motor>"
$Origen = "<cuenta>/<nombre-repo>"
# Programas: comando que debe existir e id de winget. Python en Windows se llama "py".
$Programas = @(
  @{cmd = "py"; id = "Python.Python.3.13"}
)
# -------------------------------------------------------------------------------------

$Repo = (Resolve-Path "$PSScriptRoot\..").Path
if ($Local) { $Origen = $Repo }
$Cfg = Join-Path $env:USERPROFILE ".config\$Nombre"
$Venv = Join-Path $Cfg "venv"
# Plugin: los datos no pueden ir dentro del plugin (se sustituye entero al actualizar)
$Datos = if ($Tipo -eq "plugin") { Join-Path $env:USERPROFILE $Nombre } else { Join-Path $Repo "datos" }

function Paso($t) { Write-Host "`n== $t" -ForegroundColor Cyan }
function Para($t) { Write-Host "`nNO SE PUEDE SEGUIR: $t" -ForegroundColor Red; exit 1 }
function Hay($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function RecargarPath {
  $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
}
if (("$Nombre$Tipo$Origen") -match "<") { Para "faltan los AJUSTES del principio de windows\instalar.ps1" }
New-Item -ItemType Directory -Force -Path $Cfg | Out-Null

Paso "1/5 Programas (winget)"
if (-not (Hay "git")) { Para "falta Git for Windows (obligatorio). Instálalo: winget install --id Git.Git -e  y vuelve a abrir la terminal." }
if ($Programas.Count -gt 0) {
  if (-not (Hay "winget")) { Para "falta winget. Actualiza «Instalador de aplicación» desde Microsoft Store." }
  foreach ($p in $Programas) {
    if (Hay $p.cmd) { Write-Host "Ya está: $($p.cmd)" }
    else {
      Write-Host "Instalando $($p.id)…"
      winget install --id $p.id -e --silent --accept-package-agreements --accept-source-agreements
      RecargarPath
    }
  }
}

Paso "2/5 Python propio ($Venv)"
$Py = Join-Path $Venv "Scripts\python.exe"
$Req = Join-Path $Repo "requirements.txt"
if (Test-Path $Req) {
  if (-not (Test-Path $Py)) { py -3 -m venv $Venv }
  & $Py -m pip install --quiet --disable-pip-version-check --upgrade pip
  & $Py -m pip install --quiet --disable-pip-version-check -r $Req
  Write-Host "Listo. Usar siempre: $Py"
} else { Write-Host "No hay requirements.txt: se salta." }

Paso "3/5 Librerías de la app"
if (($Tipo -eq "app") -and (Test-Path (Join-Path $Repo "app\package.json"))) {
  if (-not (Hay "npm")) { Para "falta Node. Añade @{cmd = 'node'; id = 'OpenJS.NodeJS.LTS'} a Programas." }
  Push-Location (Join-Path $Repo "app"); npm install --no-fund --no-audit; Pop-Location
} else { Write-Host "No es una app: se salta." }

Paso "4/5 Tu carpeta ($Datos)"
New-Item -ItemType Directory -Force -Path $Datos | Out-Null
Write-Host "Aquí va todo lo tuyo. Nunca se sube a GitHub."

Paso "5/5 Plugin de Claude Code"
if ($Tipo -eq "plugin") {
  if (-not (Hay "claude")) { Para "falta Claude Code. Instálalo: irm https://claude.ai/install.ps1 | iex" }
  $lista = (claude plugin marketplace list 2>$null) -join "`n"
  if ($lista -match [regex]::Escape($Nombre)) { claude plugin marketplace update $Nombre }
  else { claude plugin marketplace add $Origen }
  if (-not ((claude plugin list 2>$null) -join "`n" -match [regex]::Escape("$Nombre@$Nombre"))) { claude plugin install "$Nombre@$Nombre" }
} else { Write-Host "No es un plugin: se salta." }

Write-Host "`nHecho. Cierra esta terminal, abre una sesión NUEVA de Claude Code en esta carpeta y dile qué quieres hacer."
