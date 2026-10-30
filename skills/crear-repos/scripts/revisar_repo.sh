#!/usr/bin/env bash
# Revisa una carpeta antes de publicarla como repo de GitHub.
# Uso: bash revisar_repo.sh <carpeta> [--publico] [--bloquear "palabra1,palabra2"]
#   --publico   exige LICENSE (sin licencia, nadie puede reutilizar el código legalmente)
#   --bloquear  palabras que no pueden aparecer ni en el contenido ni en los nombres de archivo
# Sale con código 1 si hay errores. Funciona en macOS (bash 3.2) y en Git Bash de Windows.

set -u

DIR=""
PUBLICO=0
BLOQUEAR=""
while [ $# -gt 0 ]; do
  case "$1" in
    --publico) PUBLICO=1 ;;
    --bloquear) shift; BLOQUEAR="${1:-}" ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) DIR="$1" ;;
  esac
  shift
done

if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
  echo "ERROR: pasa la carpeta del repo. Ejemplo: bash revisar_repo.sh ./mi-repo --bloquear \"nombre,email\""
  exit 2
fi
cd "$DIR" || exit 2
export LC_ALL="${LC_ALL:-en_US.UTF-8}"   # para contar caracteres (no bytes) con wc -m

ERRORES=0
AVISOS=0
err()   { echo "ERROR: $*"; ERRORES=$((ERRORES + 1)); }
aviso() { echo "AVISO: $*"; AVISOS=$((AVISOS + 1)); }
ok()    { echo "OK: $*"; }

EXCL="--exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.venv --exclude-dir=venv"

echo "== Archivos base =="
if [ -f README.md ] || [ -f .github/README.md ] || [ -f docs/README.md ]; then ok "README.md"; else err "falta README.md"; fi
if [ -n "$(find . -maxdepth 1 -type f \( -iname 'LICENSE*' -o -iname 'LICENCE*' \) 2>/dev/null)" ]; then
  ok "LICENSE"
elif [ "$PUBLICO" -eq 1 ]; then
  err "falta LICENSE (obligatorio en repo público)"
else
  aviso "no hay LICENSE (bien si es privado; si va a ser público, añadir una)"
fi
if [ -f .gitignore ]; then ok ".gitignore"; else aviso "falta .gitignore (usar assets/gitignore-base)"; fi
if [ -f CLAUDE.md ]; then ok "CLAUDE.md"; else aviso "falta CLAUDE.md (el manual para Claude: assets/plantilla-CLAUDE.md)"; fi
# La carpeta datos/ es de cada usuario: si existe, tiene que estar en .gitignore
if [ -d datos ]; then
  if [ -f .gitignore ] && grep -Eq '^/?datos/?(\*)?[[:space:]]*$' .gitignore; then ok "datos/ fuera de git"
  else err "existe datos/ pero no está en .gitignore (ahí van las cosas de cada usuario)"; fi
fi

# Plantillas copiadas sin rellenar (las de assets/ son plantillas a propósito y no se miran)
# (el patrón lleva [ií] en vez de la "í" para que este script no se encuentre a sí mismo)
SIN_RELLENAR=$(grep -rIl --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=assets -e '<!-- Plantilla Maestr[ií]a' -e '="<[a-z|-]*>"' . 2>/dev/null | head -10)
if [ -n "$SIN_RELLENAR" ]; then
  echo "$SIN_RELLENAR" | sed 's/^/   /'
  err "plantillas sin rellenar (quedan <...> o el comentario de plantilla del principio): completar y borrar el comentario"
fi

echo "== Scripts para Mac y Windows =="
SCRIPTS=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  SCRIPTS=1
  # Con finales CRLF, bash falla con «\r: command not found»
  if grep -q $'\r' "$f"; then err "$f tiene finales de línea de Windows (CRLF): bash no lo ejecuta"; fi
done <<EOF
$(find . -name '*.sh' -not -path './.git/*' -not -path '*/node_modules/*' 2>/dev/null)
EOF
while IFS= read -r f; do
  [ -z "$f" ] && continue
  SCRIPTS=1
  # Sin BOM, Windows PowerShell 5.1 lee el UTF-8 como otra codificación y rompe las tildes
  if LC_ALL=C grep -q '[^ -~[:space:]]' "$f" && [ "$(head -c 3 "$f" | od -An -tx1 | tr -d ' \n')" != "efbbbf" ]; then
    aviso "$f tiene tildes u otros caracteres y no empieza con BOM: Windows PowerShell los leerá mal"
  fi
done <<EOF
$(find . -name '*.ps1' -not -path './.git/*' -not -path '*/node_modules/*' 2>/dev/null)
EOF
[ "$SCRIPTS" -eq 1 ] && ok "revisados los .sh y .ps1"
[ "$SCRIPTS" -eq 0 ] && echo "   (no hay scripts .sh ni .ps1)"

echo "== Tamaño de archivos =="
# 50 MiB = aviso de GitHub; 100 MiB = GitHub bloquea el push
GRANDES=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  BYTES=$(wc -c < "$f" | tr -d ' ')
  MIB=$((BYTES / 1048576))
  if [ "$BYTES" -gt 104857600 ]; then err "$f pesa ${MIB} MiB (> 100 MiB, GitHub lo bloquea)"; GRANDES=1
  else aviso "$f pesa ${MIB} MiB (> 50 MiB, GitHub avisa)"; GRANDES=1; fi
done <<EOF
$(find . -type f -size +51200k -not -path './.git/*' 2>/dev/null)
EOF
[ "$GRANDES" -eq 0 ] && ok "ningún archivo pasa de 50 MiB"

echo "== Archivos que no deben subirse =="
SUCIOS=$(find . \( -name '.env' -o -name '.env.*' -o -name '*.pem' -o -name '*.key' -o -name 'id_rsa*' \) -not -name '.env.example' -not -path './.git/*' 2>/dev/null)
if [ -n "$SUCIOS" ]; then
  echo "$SUCIOS" | while IFS= read -r f; do echo "   $f"; done
  err "hay archivos de secretos (.env, claves). Sacarlos y añadirlos a .gitignore"
else ok "sin .env ni claves"; fi
BASURA=$(find . \( -name '.DS_Store' -o -name 'Thumbs.db' \) -not -path './.git/*' 2>/dev/null | head -5)
if [ -n "$BASURA" ]; then aviso "hay .DS_Store/Thumbs.db (ponerlos en .gitignore): $(echo "$BASURA" | tr '\n' ' ')"; else ok "sin basura del sistema"; fi

echo "== Secretos en el contenido =="
# Formatos públicos de claves: OpenAI/Anthropic, GitHub, AWS, Google, Slack, claves privadas
PATRON='((^|[^A-Za-z0-9])sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|xox[baprs]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)'
# shellcheck disable=SC2086
HALLADOS=$(grep -rInIE $EXCL "$PATRON" . 2>/dev/null | head -20)
if [ -n "$HALLADOS" ]; then
  echo "$HALLADOS" | cut -c1-160 | sed 's/^/   /'
  err "posibles claves o tokens. Si ya estuvieron en un commit: revocarlos primero (references/seguridad.md)"
else ok "sin claves conocidas"; fi

echo "== Rutas personales =="
# shellcheck disable=SC2086
RUTAS=$(grep -rInIE $EXCL '(/Users/[A-Za-z0-9._-]+/|/home/[A-Za-z0-9._-]+/|[A-Z]:\\Users\\[A-Za-z0-9._-]+)' . 2>/dev/null | head -20)
if [ -n "$RUTAS" ]; then
  echo "$RUTAS" | cut -c1-160 | sed 's/^/   /'
  aviso "rutas de un ordenador concreto: revelan el usuario y no funcionan en otro equipo (usar rutas relativas o \${CLAUDE_SKILL_DIR}). Ignorar solo si son ejemplos genéricos"
else ok "sin rutas personales"; fi

if [ -n "$BLOQUEAR" ]; then
  echo "== Palabras bloqueadas =="
  OLDIFS="$IFS"; IFS=','
  for w in $BLOQUEAR; do
    IFS="$OLDIFS"
    w=$(echo "$w" | sed 's/^ *//;s/ *$//')
    [ -z "$w" ] && continue
    # shellcheck disable=SC2086
    EN_TEXTO=$(grep -rIniF $EXCL -- "$w" . 2>/dev/null | head -10)
    EN_NOMBRE=$(find . -iname "*$w*" -not -path './.git/*' 2>/dev/null | head -10)
    if [ -n "$EN_TEXTO$EN_NOMBRE" ]; then
      [ -n "$EN_TEXTO" ] && echo "$EN_TEXTO" | cut -c1-160 | sed 's/^/   /'
      [ -n "$EN_NOMBRE" ] && echo "$EN_NOMBRE" | sed 's/^/   (nombre) /'
      err "aparece la palabra bloqueada \"$w\""
    else ok "no aparece \"$w\""; fi
    IFS=','
  done
  IFS="$OLDIFS"
fi

echo "== Skills (SKILL.md) =="
NSKILLS=0
while IFS= read -r s; do
  [ -z "$s" ] && continue
  NSKILLS=$((NSKILLS + 1))
  CARPETA=$(basename "$(dirname "$s")")
  PRIMERA=$(head -n 1 "$s" | tr -d '\r')
  if [ "$PRIMERA" != "---" ]; then err "$s: la primera línea debe ser --- (si no, la skill carga sin nombre ni description)"; continue; fi
  # Frontmatter = líneas entre el primer y el segundo ---
  FM=$(awk 'NR==1{next} /^---[[:space:]]*$/{exit} {print}' "$s" | tr -d '\r')
  FIN=$(awk 'NR>1 && /^---[[:space:]]*$/{print NR; exit}' "$s")
  if [ -z "$FIN" ]; then err "$s: el frontmatter no se cierra con ---"; continue; fi

  NAME=$(echo "$FM" | sed -n 's/^name:[[:space:]]*//p' | head -1 | sed "s/^[\"']//;s/[\"'][[:space:]]*$//;s/[[:space:]]*$//")
  if [ -z "$NAME" ]; then
    aviso "$s: sin name (Claude Code usa la carpeta \"$CARPETA\"; claude.ai y la API lo exigen)"
  else
    if ! echo "$NAME" | grep -Eq '^[a-z0-9]([a-z0-9-]{0,62}[a-z0-9])?$' || echo "$NAME" | grep -q -- '--'; then
      err "$s: name \"$NAME\" inválido (1-64, solo a-z 0-9 y -, sin - al inicio/final ni --)"
    fi
    [ "$NAME" != "$CARPETA" ] && err "$s: name \"$NAME\" distinto de su carpeta \"$CARPETA\""
    echo "$NAME" | grep -Eq 'claude|anthropic' && err "$s: name con palabra reservada (claude/anthropic)"
  fi

  # description: en una línea, o en bloque con > o | seguido de líneas sangradas
  DESC=$(echo "$FM" | awk '
    /^description:/ { sub(/^description:[[:space:]]*/, ""); if ($0 ~ /^[>|][-+]?$/ || $0 == "") { blk=1; next } print; exit }
    blk && /^[[:space:]]+/ { sub(/^[[:space:]]+/, ""); printf "%s ", $0; next }
    blk { exit }')
  DESC=$(echo "$DESC" | sed "s/^[\"']//;s/[\"'][[:space:]]*$//;s/[[:space:]]*$//")
  if [ -z "$DESC" ]; then
    err "$s: falta description (es lo que decide si Claude la usa)"
  else
    LEN=$(printf '%s' "$DESC" | wc -m | tr -d ' ')
    if [ "$LEN" -gt 1024 ]; then err "$s: description de $LEN caracteres (máx. 1024)"
    else ok "$s: description de $LEN caracteres"; fi
    echo "$DESC" | grep -Eiq '^(i |i'"'"'m|puedo |te ayudo|you can|puedes )' && aviso "$s: description en primera/segunda persona; mejor en tercera (\"Crea...\", \"Procesa...\")"
    echo "$DESC" | grep -Eq '<[A-Za-z/][^>]*>' && err "$s: description con etiquetas tipo XML (<...>), no permitidas"
  fi

  TOTAL=$(wc -l < "$s" | tr -d ' ')
  CUERPO=$((TOTAL - FIN))
  [ "$CUERPO" -gt 500 ] && aviso "$s: cuerpo de $CUERPO líneas (> 500): pasar detalle a references/"
  grep -Eq '(scripts|references|assets)\\' "$s" && aviso "$s: rutas con \\ (usar / para que funcione en Mac y Linux)"
  # Enlaces a archivos de la propia skill que no existen
  BASE=$(dirname "$s")
  for ref in $(grep -oE '\]\((references|scripts|assets)/[^)#]+' "$s" | sed 's/^](//' | sort -u); do
    [ -e "$BASE/$ref" ] || err "$s: enlaza a $ref, que no existe"
  done
done <<EOF
$(find . -name SKILL.md -not -path './.git/*' -not -path '*/node_modules/*' 2>/dev/null | sort)
EOF
[ "$NSKILLS" -eq 0 ] && echo "   (no hay skills)"

echo "== Plugin y marketplace =="
if [ -d .claude-plugin ]; then
  # En Windows "python3" puede ser el acceso directo de la Microsoft Store, que existe pero no ejecuta nada:
  # por eso se prueba de verdad en vez de solo mirar si el comando existe.
  PY=""
  for c in python3 python; do
    if command -v "$c" >/dev/null 2>&1 && "$c" -I -c 'import json' >/dev/null 2>&1; then PY="$c"; break; fi
  done
  [ -z "$PY" ] && aviso "no hay Python: no se revisaron los JSON del plugin aquí (claude plugin validate, abajo, sí los revisa)"
  for j in .claude-plugin/*.json; do
    [ -f "$j" ] || continue
    if [ -n "$PY" ]; then
      if "$PY" -I -m json.tool "$j" >/dev/null 2>&1; then ok "$j es JSON válido"; else err "$j no es JSON válido"; fi
    fi
  done
  if [ -n "$PY" ] && [ -f .claude-plugin/marketplace.json ] && [ -f .claude-plugin/plugin.json ]; then
    PYOUT=$("$PY" -I - <<'PY'
import json, sys
m = json.load(open(".claude-plugin/marketplace.json", encoding="utf-8"))
p = json.load(open(".claude-plugin/plugin.json", encoding="utf-8"))
raiz = [e for e in m.get("plugins", []) if e.get("source") in ("./", ".")]
for e in raiz:
    if e.get("name") != p.get("name"):
        print(f'ERROR: el plugin se llama "{e.get("name")}" en marketplace.json y "{p.get("name")}" en plugin.json (deben ser iguales)')
        sys.exit(1)
    if "version" in e and "version" in p:
        print("AVISO: version en marketplace.json y en plugin.json; dejarla solo en uno (gana plugin.json)")
print("OK: nombres de plugin coinciden")
PY
)
    echo "$PYOUT"
    ERRORES=$((ERRORES + $(echo "$PYOUT" | grep -c '^ERROR')))
    AVISOS=$((AVISOS + $(echo "$PYOUT" | grep -c '^AVISO')))
  fi
  if command -v claude >/dev/null 2>&1; then
    SALIDA=$(claude plugin validate . 2>&1)
    if echo "$SALIDA" | grep -q 'Validation passed'; then ok "claude plugin validate"
    else echo "$SALIDA" | tail -15 | sed 's/^/   /'; err "claude plugin validate no pasa"; fi
  else
    aviso "claude no está instalado: no se pudo ejecutar claude plugin validate"
  fi
else
  echo "   (no hay .claude-plugin/)"
fi

echo
if [ "$ERRORES" -gt 0 ]; then
  echo "RESULTADO: FALLA ($ERRORES errores, $AVISOS avisos)"
  exit 1
fi
echo "RESULTADO: OK ($AVISOS avisos)"
