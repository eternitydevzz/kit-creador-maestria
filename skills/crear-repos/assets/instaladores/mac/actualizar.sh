#!/usr/bin/env bash
# Actualiza <Nombre del proyecto> en un Mac: baja lo último del repo, las librerías y el plugin.
# Uso: bash mac/actualizar.sh
set -euo pipefail

# ---- AJUSTES (los mismos que en mac/instalar.sh) ----
NOMBRE="<nombre-repo>"
TIPO="<app|plugin|motor>"
# ------------------------------------------------------

REPO="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$HOME/.config/$NOMBRE/venv"
case "$NOMBRE$TIPO" in *"<"*) echo "NO SE PUEDE SEGUIR: faltan los AJUSTES de mac/actualizar.sh" >&2; exit 1 ;; esac

echo "== 1/3 Repo"
git -C "$REPO" pull --ff-only

echo "== 2/3 Librerías"
if [ -f "$REPO/requirements.txt" ] && [ -x "$VENV/bin/python" ]; then
  "$VENV/bin/python" -m pip install --quiet --disable-pip-version-check -r "$REPO/requirements.txt"
fi
if [ "$TIPO" = "app" ] && [ -f "$REPO/app/package.json" ]; then
  (cd "$REPO/app" && npm install --no-fund --no-audit)
fi

echo "== 3/3 Plugin"
if [ "$TIPO" = "plugin" ]; then
  claude plugin marketplace update "$NOMBRE"
  claude plugin update "$NOMBRE@$NOMBRE" || true   # sale con error si ya estaba al día
fi

echo "Hecho. Abre una sesión NUEVA de Claude Code para usar la versión nueva."
