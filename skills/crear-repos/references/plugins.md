# Compartir skills con un comando: plugin + marketplace

## Contenido
- Qué opción elegir
- El repo que es marketplace y plugin a la vez
- plugin.json
- marketplace.json
- Validar y probar en local
- Cómo lo instala el equipo
- Repos privados: acceso
- Instalarlo solo para todo el que abra un repo
- Versiones y actualizaciones
- Renombrar o quitar plugins
- Errores típicos

## Qué opción elegir

| Situación | Opción |
|---|---|
| Skills solo para un proyecto | `.claude/skills/<nombre>/` dentro del repo del proyecto. Se cargan solas al abrirlo |
| Pasar una skill a 2-3 personas | Mandar la carpeta (o un `.zip`) para `~/.claude/skills/` |
| Equipo o público que debe instalar y recibir actualizaciones | **Plugin + marketplace en un repo de GitHub** (lo recomendado) |
| Para todo el mundo con revisión | Enviar al directorio de Anthropic |

## El repo que es marketplace y plugin a la vez

```
mi-repo/
├── .claude-plugin/
│   ├── marketplace.json
│   └── plugin.json
├── skills/
│   ├── skill-uno/SKILL.md
│   └── skill-dos/SKILL.md
└── README.md
```

- Dentro de `.claude-plugin/` solo van `plugin.json` y `marketplace.json`. Si `skills/` se mete ahí dentro, no carga.
- Otros componentes opcionales en la raíz del plugin: `agents/` (un .md por subagente), `hooks/hooks.json`, `.mcp.json`, `commands/` (formato viejo; usar `skills/`).
- Las skills de un plugin se llaman con prefijo: `/mi-plugin:skill-uno`.
- No poner carpeta `bin/` en la raíz si se va a sincronizar por claude.ai (la rechaza); scripts en `scripts/` y referenciados con `${CLAUDE_PLUGIN_ROOT}/scripts/...`.
- No guardar archivos del plugin en Git LFS: al clonar llegan como punteros vacíos.

Varios plugins en un repo: `plugins/<nombre>/.claude-plugin/plugin.json` cada uno, y en marketplace.json `"source": "./plugins/<nombre>"`.

## plugin.json

```json
{
  "name": "mi-plugin",
  "description": "Qué trae, en una frase",
  "version": "1.0.0",
  "author": { "name": "Equipo X" }
}
```

- `name` obligatorio, sin espacios; es el prefijo de las skills.
- `author.name` obligatorio si se pone `author`. En repos que no deben llevar datos personales, usar el nombre de la marca o equipo.
- Para cambiar el nombre visible sin romper nada: `displayName`.

## marketplace.json

```json
{
  "name": "mi-marketplace",
  "description": "Skills de X para el equipo",
  "owner": { "name": "Equipo X" },
  "plugins": [
    {
      "name": "mi-plugin",
      "source": "./",
      "description": "Qué trae, en una frase"
    }
  ]
}
```

- Obligatorios: `name`, `owner` (con `name`) y `plugins`. Cada plugin: `name` y `source`.
- `"source": "./"` = el propio repo es el plugin. Rutas relativas siempre empiezan por `./`, se cuentan desde la raíz del repo (no desde `.claude-plugin/`) y no pueden usar `..`.
- El `name` del plugin en marketplace.json y en plugin.json deben ser **iguales** (si no: `Plugin not found in marketplace`).
- Nombres: letras, números, `.`, `_` y `-`, empezando por letra o número. Sin espacios.
- Elegir un nombre de marketplace que nadie más vaya a usar: un usuario no puede tener dos marketplaces con el mismo nombre.
- Nombres reservados (fallan): `claude-plugins-official`, `anthropic-agent-skills`, `agent-skills`, `claude-code-plugins`, `github`, `npm`, cualquiera que imite uno oficial (`claude-plugins-v2`), que lleve caracteres no ASCII o que empiece por `claudeai-`.
- Otras fuentes posibles por plugin: `{"source": "github", "repo": "org/repo", "ref": "v1.0.0"}`, `git-subdir` (una carpeta de otro repo), `url`, `npm`, `archive` (zip por HTTPS).

## Validar y probar en local

```bash
claude plugin validate ./mi-repo                  # debe terminar en "✔ Validation passed"
claude plugin marketplace add ./mi-repo
claude plugin install mi-plugin@mi-marketplace
claude plugin list                                # "Status: ✔ enabled"
claude plugin details mi-plugin                   # lista las skills que encontró
```

- Solo para una sesión, sin instalar: `claude --plugin-dir ./mi-repo`. Tras editar: `/reload-plugins`.
- `validate` no detecta todo: una ruta que no existe solo falla al instalar (`Source path does not exist`).
- Para quitarlo y empezar de cero: `claude plugin marketplace remove mi-marketplace`.

## Cómo lo instala el equipo

Dentro de Claude Code:
```
/plugin marketplace add cuenta/mi-repo
/plugin install mi-plugin@mi-marketplace
```
O en la terminal: `claude plugin marketplace add cuenta/mi-repo` y `claude plugin install mi-plugin@mi-marketplace`.

Después, abrir una sesión nueva y probar con una frase real que la skill se activa.

## Repos privados: acceso

Claude Code usa el `git` del usuario sin poder preguntarle nada, así que cada persona necesita credenciales ya guardadas:
- **Lo más simple (HTTPS con gh)**: `gh auth login` y luego `gh auth setup-git`.
- **SSH**: clave cargada en `ssh-agent` (sin pedir contraseña) y github.com en `known_hosts`.
- Quien no tenga clave SSH de GitHub: poner `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` para que no lo intente por SSH (las instalaciones desde `/plugin` y las actualizaciones no cambian solas a HTTPS).
- Poner `GITHUB_TOKEN` en el entorno no basta por sí solo; tiene que pasar por un credential helper (el de `gh` lo lee).
- Cada persona tiene que tener acceso de lectura al repo (invitarla como colaboradora o vía equipo de la organización).

## Instalarlo solo para todo el que abra un repo

En el repo del proyecto, una vez:
```bash
claude plugin marketplace add cuenta/mi-repo --scope project
```
y hacer commit del `.claude/settings.json` que escribe. A cada compañero que confíe en la carpeta se le registra el marketplace. Para activar plugins también: `enabledPlugins` en ese settings.

## Versiones y actualizaciones

- El usuario recibe una copia nueva solo si cambia la versión calculada:
  - Con `"version"` en plugin.json → hay que **subirla en cada cambio** o nadie recibe nada.
  - Sin `version` en ningún sitio → sigue los commits.
  - Nunca `version` en plugin.json y en marketplace.json a la vez (gana plugin.json y avisa).
- El auto-update viene apagado: cada usuario lo enciende en `/plugin` → Marketplaces → Enable auto-update. Si no, actualiza con `/plugin marketplace update mi-marketplace`.
- Canales estable/beta: dos marketplaces con nombre distinto apuntando a ramas distintas (`"ref": "stable"` / `"ref": "latest"`).
- Fijar una versión: `ref` (rama o tag) y `sha` (commit de 40 caracteres) en la fuente del plugin.

## Renombrar o quitar plugins

Cambiar `name` rompe todas las instalaciones. Si hay que hacerlo, añadir `renames` en marketplace.json:
```json
"renames": { "nombre-viejo": "nombre-nuevo", "plugin-borrado": null }
```
Es historial: no se borra lo viejo, se añade. `"forceRemoveDeletedPlugins": true` desinstala de los equipos los plugins quitados.

## Errores típicos

- Carpetas de componentes dentro de `.claude-plugin/` → no cargan.
- `--plugin-dir` apuntando a la raíz de un marketplace con plugins en `plugins/` → no carga nada y no avisa.
- Nombre distinto en marketplace.json y plugin.json.
- Subir cambios sin tocar `version` → el equipo no los recibe.
- Ruta con `\` → falla en Mac/Linux.
- Marketplace con nombre reservado → se rechaza al añadirlo.
