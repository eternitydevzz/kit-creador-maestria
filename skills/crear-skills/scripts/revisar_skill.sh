#!/usr/bin/env bash
# Revisa una skill (carpeta con SKILL.md) o una carpeta con varias skills.
# Uso: bash revisar_skill.sh <carpeta>
# Sale con código 1 si hay errores. Funciona en macOS (bash 3.2) y en Git Bash de Windows.

set -u

DIR="${1:-}"
case "$DIR" in -h|--help) sed -n '2,4p' "$0"; exit 0 ;; esac
if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
  echo "ERROR: pasa la carpeta de la skill. Ejemplo: bash revisar_skill.sh ~/.claude/skills/mi-skill"
  exit 2
fi
cd "$DIR" || exit 2
export LC_ALL="${LC_ALL:-en_US.UTF-8}"   # para contar caracteres (no bytes) con wc -m

ERRORES=0
AVISOS=0
err()   { echo "ERROR: $*"; ERRORES=$((ERRORES + 1)); }
aviso() { echo "AVISO: $*"; AVISOS=$((AVISOS + 1)); }
ok()    { echo "OK: $*"; }

LISTA=$(find . -name SKILL.md -not -path '*/.git/*' -not -path '*/node_modules/*' 2>/dev/null | sort)
if [ -z "$LISTA" ]; then
  echo "ERROR: no hay ningún SKILL.md en $DIR"
  exit 1
fi

while IFS= read -r s; do
  [ -z "$s" ] && continue
  BASE=$(dirname "$s")
  # Si se pasa la carpeta de la propia skill, su nombre es el de la carpeta actual
  if [ "$BASE" = "." ]; then CARPETA=$(basename "$(pwd)"); else CARPETA=$(basename "$BASE"); fi
  echo "== $CARPETA =="
  # Claude Code reserva la carpeta "synced" para las skills que baja de claude.ai
  echo "$CARPETA" | grep -iqx 'synced' && err "la carpeta no puede llamarse \"synced\" (nombre reservado de Claude Code)"

  PRIMERA=$(head -n 1 "$s" | tr -d '\r')
  if [ "$PRIMERA" != "---" ]; then err "la primera línea debe ser --- (si no, la skill carga sin nombre ni description)"; continue; fi
  FM=$(awk 'NR==1{next} /^---[[:space:]]*$/{exit} {print}' "$s" | tr -d '\r')
  FIN=$(awk 'NR>1 && /^---[[:space:]]*$/{print NR; exit}' "$s")
  if [ -z "$FIN" ]; then err "el frontmatter no se cierra con ---"; continue; fi

  # name
  NAME=$(echo "$FM" | sed -n 's/^name:[[:space:]]*//p' | head -1 | sed "s/^[\"']//;s/[\"'][[:space:]]*$//;s/[[:space:]]*$//")
  if [ -z "$NAME" ]; then
    aviso "sin name (Claude Code usa la carpeta \"$CARPETA\"; claude.ai y la API lo exigen)"
  else
    if ! echo "$NAME" | grep -Eq '^[a-z0-9]([a-z0-9-]{0,62}[a-z0-9])?$' || echo "$NAME" | grep -q -- '--'; then
      err "name \"$NAME\" inválido (1-64, solo a-z 0-9 y -, sin - al inicio/final ni --)"
    fi
    [ "$NAME" != "$CARPETA" ] && err "name \"$NAME\" distinto de su carpeta \"$CARPETA\""
    echo "$NAME" | grep -Eq 'claude|anthropic' && err "name con palabra reservada (claude/anthropic)"
  fi

  # description: en una línea, o en bloque con > o | seguido de líneas sangradas
  DESC=$(echo "$FM" | awk '
    /^description:/ { sub(/^description:[[:space:]]*/, ""); if ($0 ~ /^[>|][-+]?$/ || $0 == "") { blk=1; next } print; exit }
    blk && /^[[:space:]]+/ { sub(/^[[:space:]]+/, ""); printf "%s ", $0; next }
    blk { exit }')
  DESC=$(echo "$DESC" | sed "s/^[\"']//;s/[\"'][[:space:]]*$//;s/[[:space:]]*$//")
  if [ -z "$DESC" ]; then
    err "falta description (es lo que decide si Claude la usa)"
  else
    LEN=$(printf '%s' "$DESC" | wc -m | tr -d ' ')
    # 1024 = límite de la especificación Agent Skills
    if [ "$LEN" -gt 1024 ]; then err "description de $LEN caracteres (máx. 1024)"
    else ok "description de $LEN caracteres"; fi
    # Menos de 100 caracteres casi nunca dice qué hace Y cuándo usarla
    [ "$LEN" -lt 100 ] && aviso "description muy corta ($LEN caracteres): decir qué hace y con qué frases se usa"
    echo "$DESC" | grep -Eiq '^(i |i'"'"'m|puedo |te ayudo|you can|puedes )' && aviso "description en primera/segunda persona; mejor en tercera (\"Crea...\", \"Procesa...\")"
    echo "$DESC" | grep -Eq '<[A-Za-z/][^>]*>' && err "description con etiquetas tipo XML (<...>), no permitidas"
    echo "$DESC" | grep -Eiq '(úsala|usar|use when|use this|cuando)' || aviso "la description no dice cuándo usarla (\"Úsala siempre que el usuario diga ...\")"
  fi

  # Cuerpo: 500 líneas = recomendación oficial de Claude Code
  TOTAL=$(wc -l < "$s" | tr -d ' ')
  CUERPO=$((TOTAL - FIN))
  if [ "$CUERPO" -gt 500 ]; then aviso "cuerpo de $CUERPO líneas (> 500): pasar detalle a references/"
  else ok "cuerpo de $CUERPO líneas"; fi

  grep -Eq '(scripts|references|assets)\\' "$s" && aviso "rutas con \\ (usar / para que funcione en Mac y Linux)"

  # Rutas personales en cualquier archivo de la skill
  RUTAS=$(grep -rInIE '(/Users/[A-Za-z0-9._-]+/|/home/[A-Za-z0-9._-]+/|[A-Z]:\\Users\\[A-Za-z0-9._-]+)' "$BASE" 2>/dev/null | head -10)
  if [ -n "$RUTAS" ]; then
    echo "$RUTAS" | cut -c1-160 | sed 's/^/   /'
    aviso "rutas de un ordenador concreto: no funcionan en otro equipo y revelan el usuario (usar \${CLAUDE_SKILL_DIR}). Ignorar si son ejemplos genéricos"
  fi

  # Enlaces a archivos de la propia skill que no existen
  ROTOS=0
  for ref in $(grep -oE '\]\((references|scripts|assets)/[^)#]+' "$s" | sed 's/^](//' | sort -u); do
    [ -e "$BASE/$ref" ] || { err "enlaza a $ref, que no existe"; ROTOS=1; }
  done
  # Archivos de references/ que SKILL.md no menciona: Claude no sabrá que existen
  if [ -d "$BASE/references" ]; then
    for f in "$BASE"/references/*; do
      [ -f "$f" ] || continue
      n=$(basename "$f")
      grep -q "references/$n" "$s" || aviso "references/$n no se menciona en SKILL.md (Claude no sabrá que existe)"
    done
  fi
  [ "$ROTOS" -eq 0 ] && ok "enlaces internos"
done <<EOF
$LISTA
EOF

echo
if [ "$ERRORES" -gt 0 ]; then
  echo "RESULTADO: FALLA ($ERRORES errores, $AVISOS avisos)"
  exit 1
fi
echo "RESULTADO: OK ($AVISOS avisos)"
