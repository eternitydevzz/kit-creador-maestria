#!/usr/bin/env bash
# Instala <Nombre del proyecto> en un Mac. Antes hay que haber hecho «Antes de empezar» de INSTALAR.md.
# Uso:  bash mac/instalar.sh            (plugin desde GitHub)
#       bash mac/instalar.sh --local    (plugin desde esta carpeta, para probar)
# Se puede repetir: lo que ya está hecho se salta.
set -euo pipefail

# ---- AJUSTES (rellenar al crear el proyecto) ----
NOMBRE="<nombre-repo>"                 # minúsculas y guiones; carpeta de ajustes y plugin
TIPO="<app|plugin|motor>"              # app = interfaz local · plugin = skills · motor = scripts
ORIGEN="<cuenta>/<nombre-repo>"        # de dónde se instala el plugin (solo tipo plugin)
PROGRAMAS="python3:python"             # "comando:paquete-de-brew" separados por espacio; vacío si no hace falta nada
# ---------------------------------------------------

REPO="$(cd "$(dirname "$0")/.." && pwd)"
[ "${1:-}" = "--local" ] && ORIGEN="$REPO"
CFG="$HOME/.config/$NOMBRE"
VENV="$CFG/venv"
# Plugin: los datos no pueden ir dentro del plugin (se sustituye entero al actualizar)
if [ "$TIPO" = "plugin" ]; then DATOS="$HOME/$NOMBRE"; else DATOS="$REPO/datos"; fi

paso() { printf '\n== %s\n' "$1"; }
para() { printf '\nNO SE PUEDE SEGUIR: %s\n' "$1" >&2; exit 1; }
case "$NOMBRE$TIPO$ORIGEN" in *"<"*) para "faltan los AJUSTES del principio de mac/instalar.sh" ;; esac
mkdir -p "$CFG"

paso "1/5 Homebrew y programas"
if [ -n "$PROGRAMAS" ]; then
  command -v brew >/dev/null || para "falta Homebrew. Instálalo tú (pide la contraseña del Mac): https://brew.sh"
  faltan=()
  for par in $PROGRAMAS; do
    command -v "${par%%:*}" >/dev/null || faltan+=("${par#*:}")
  done
  if [ ${#faltan[@]} -gt 0 ]; then
    echo "Instalando: ${faltan[*]}"
    brew install "${faltan[@]}"
  else
    echo "Ya están todos."
  fi
else
  echo "No hace falta ninguno."
fi

paso "2/5 Python propio ($VENV)"
if [ -f "$REPO/requirements.txt" ]; then
  [ -x "$VENV/bin/python" ] || python3 -m venv "$VENV"
  "$VENV/bin/python" -m pip install --quiet --disable-pip-version-check --upgrade pip
  "$VENV/bin/python" -m pip install --quiet --disable-pip-version-check -r "$REPO/requirements.txt"
  echo "Listo. Usar siempre: $VENV/bin/python"
else
  echo "No hay requirements.txt: se salta."
fi

paso "3/5 Librerías de la app"
if [ "$TIPO" = "app" ] && [ -f "$REPO/app/package.json" ]; then
  command -v npm >/dev/null || para "falta Node. Añade node:node a PROGRAMAS o instálalo: brew install node"
  (cd "$REPO/app" && npm install --no-fund --no-audit)
else
  echo "No es una app: se salta."
fi

paso "4/5 Tu carpeta ($DATOS)"
mkdir -p "$DATOS"
[ -f "$DATOS/.env" ] && chmod 600 "$DATOS/.env"
echo "Aquí va todo lo tuyo. Nunca se sube a GitHub."

paso "5/5 Plugin de Claude Code"
if [ "$TIPO" = "plugin" ]; then
  command -v claude >/dev/null || para "falta Claude Code. Instálalo: curl -fsSL https://claude.ai/install.sh | bash"
  if claude plugin marketplace list 2>/dev/null | grep -q "$NOMBRE"; then
    claude plugin marketplace update "$NOMBRE"
  else
    claude plugin marketplace add "$ORIGEN"
  fi
  claude plugin list 2>/dev/null | grep -q "$NOMBRE@$NOMBRE" || claude plugin install "$NOMBRE@$NOMBRE"
else
  echo "No es un plugin: se salta."
fi

echo
echo "Hecho. Abre una sesión NUEVA de Claude Code en esta carpeta y dile qué quieres hacer."
