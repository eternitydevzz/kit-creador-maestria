# Actualiza <Nombre del proyecto> en Windows: baja lo último del repo, las librerías y el plugin.
# Uso: windows\actualizar.cmd
$ErrorActionPreference = "Stop"

# ---- AJUSTES (los mismos que en windows\instalar.ps1) ----
$Nombre = "<nombre-repo>"
$Tipo = "<app|plugin|motor>"
# -----------------------------------------------------------

$Repo = (Resolve-Path "$PSScriptRoot\..").Path
$Py = Join-Path $env:USERPROFILE ".config\$Nombre\venv\Scripts\python.exe"
if (("$Nombre$Tipo") -match "<") { Write-Host "NO SE PUEDE SEGUIR: faltan los AJUSTES de windows\actualizar.ps1" -ForegroundColor Red; exit 1 }

Write-Host "== 1/3 Repo"
git -C $Repo pull --ff-only

Write-Host "== 2/3 Librerías"
$Req = Join-Path $Repo "requirements.txt"
if ((Test-Path $Req) -and (Test-Path $Py)) { & $Py -m pip install --quiet --disable-pip-version-check -r $Req }
if (($Tipo -eq "app") -and (Test-Path (Join-Path $Repo "app\package.json"))) {
  Push-Location (Join-Path $Repo "app"); npm install --no-fund --no-audit; Pop-Location
}

Write-Host "== 3/3 Plugin"
if ($Tipo -eq "plugin") {
  claude plugin marketplace update $Nombre
  claude plugin update "$Nombre@$Nombre"   # da error si ya estaba al día: no pasa nada
}

Write-Host "Hecho. Abre una sesión NUEVA de Claude Code para usar la versión nueva."
