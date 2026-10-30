# Cómo escribir skills que funcionen

## Contenido
- Qué es una skill y cómo la carga Claude
- Frontmatter (campos y límites)
- La description: lo que decide si se activa
- El cuerpo: corto, claro y con el porqué
- Estructura de carpetas y archivos de apoyo
- Scripts dentro de la skill
- Campos extra de Claude Code
- Dónde vive la skill
- Errores típicos
- Checklist antes de compartir

## Qué es una skill y cómo la carga Claude

Una carpeta con un `SKILL.md` (frontmatter YAML + instrucciones en Markdown) y, si hace falta, `scripts/`, `references/` y `assets/`. Es un estándar abierto (agentskills.io) que usan Claude Code, claude.ai y la API.

Carga en 3 niveles (progressive disclosure):
1. **Metadatos** (~100 tokens): `name` y `description` de todas las skills están siempre en contexto.
2. **Instrucciones** (recomendado < 5.000 tokens): el cuerpo de SKILL.md se lee solo cuando la skill se activa.
3. **Recursos**: los demás archivos se leen o ejecutan solo cuando hacen falta. Un archivo no leído no gasta contexto.

Consecuencia: la description tiene que vender la skill; el cuerpo tiene que ser corto; lo pesado va aparte.

## Frontmatter (campos y límites)

| Campo | Obligatorio | Regla |
|---|---|---|
| `name` | Sí (en Claude Code toma el nombre de la carpeta si falta) | 1–64 caracteres; solo `a-z`, `0-9` y `-`; sin guion al inicio/final ni `--`; **igual que la carpeta**; sin etiquetas XML; sin las palabras `anthropic` ni `claude`; no usar `synced` (Claude Code lo reserva para las skills que baja de claude.ai) |
| `description` | Sí | 1–1.024 caracteres; sin etiquetas XML; qué hace + cuándo usarla |
| `license` | No | Nombre corto (`MIT`) o archivo incluido (`LICENSE.txt`) |
| `compatibility` | No | Máx. 500 caracteres; solo si necesita algo especial (`Requiere git, ffmpeg e internet`) |
| `metadata` | No | Pares clave–valor de texto (`author`, `version`) |
| `allowed-tools` | No (experimental) | Herramientas pre-aprobadas separadas por espacio: `Bash(git:*) Read` |

Fuera de Claude Code (subir a claude.ai, Skills API) solo se aceptan esos 6 campos; cualquier otro da error. Si la skill se va a compartir en esos sitios, no usar campos exclusivos de Claude Code.

Nombres: mejor en forma de acción (`crear-repos`, `analizar-hojas`, `adaptar-fotos`). Evitar vagos (`helper`, `utils`, `tools`) y genéricos (`datos`, `archivos`). Mismo patrón en toda la colección.

## La description: lo que decide si se activa

Claude elige entre potencialmente 100+ skills leyendo solo la description. Reglas:
- **Tercera persona**: "Procesa archivos Excel y genera informes". Nunca "Puedo ayudarte..." ni "Puedes usar esto...": se inyecta en el system prompt y el punto de vista mezclado confunde la elección.
- **Qué hace + cuándo**: verbos concretos y luego "Úsala siempre que el usuario diga ...", con las frases y palabras reales que usaría (incluye sinónimos, extensiones de archivo, nombres de herramientas).
- **Un poco insistente**: Claude tiende a NO activar skills cuando le servirían ("undertriggering"). Listar contextos de uso con claridad lo compensa.
- **Lo importante primero**: Claude Code corta `description` + `when_to_use` a 1.536 caracteres en el listado.
- Tareas muy simples de un paso pueden no activar la skill aunque la description coincida: es normal.
- **Que no pise a otra skill**: si hay dos skills parecidas, cada description dice para qué es la suya y cuándo usar la otra.

Bien: `Extrae texto y tablas de PDF, rellena formularios y une documentos. Úsala cuando haya archivos PDF o el usuario hable de PDF, formularios o extraer texto de documentos.`
Mal: `Ayuda con PDFs.`

## El cuerpo: corto, claro y con el porqué

- **Claude ya es listo**: añadir solo lo que no sabe (tus reglas, tus rutas, tus decisiones, tus números). Preguntarse en cada párrafo: "¿le hace falta esto?".
- **Menos de 500 líneas**. Si crece, partir en archivos de `references/`.
- **Explicar el porqué** de cada regla en vez de gritar. Escribir SIEMPRE/NUNCA en mayúsculas es señal de alarma: mejor una frase con el motivo.
- **Grados de libertad según el riesgo**:
  - Alta (texto con criterios) cuando hay muchas formas válidas.
  - Media (plantilla o pseudocódigo) cuando hay un patrón preferido.
  - Baja (comando exacto, "no cambies los flags") cuando un error rompe algo.
- **Flujos con pasos numerados** y, si son largos, una checklist que Claude copia y marca.
- **Bucles de validación**: ejecutar comprobación → corregir → repetir hasta que pase.
- **Ejemplos concretos** de entrada → salida cuando el estilo importa.
- **Una opción por defecto** con su salida de emergencia, no cinco alternativas.
- **Términos consistentes**: elegir una palabra ("campo", "extraer") y no cambiarla.
- **Nada que caduque** ("antes de agosto usar..."). Lo viejo en una sección "Formas antiguas".
- **Herramientas MCP con nombre completo**: `Servidor:herramienta`.
- **Pedir permiso antes de lo que no tiene vuelta atrás** (publicar, enviar, borrar): decirlo en el paso concreto.

## Estructura de carpetas y archivos de apoyo

```
mi-skill/
├── SKILL.md          # índice y flujo
├── references/       # docs que Claude lee cuando toca (una por tema)
├── scripts/          # código que Claude ejecuta
└── assets/           # plantillas, imágenes, datos
```

- Enlazar cada archivo **directamente desde SKILL.md** (un solo nivel). Si un archivo enlaza a otro que enlaza a otro, Claude puede leerlos a medias.
- Archivos de referencia de más de 100 líneas: índice ("Contenido") al principio.
- Nombres que digan lo que hay: `reglas_validacion.md`, no `doc2.md`.
- Organizar por tema (`references/finanzas.md`, `references/ventas.md`) para que solo se lea lo necesario.
- Rutas siempre con `/` y relativas a la skill. En Claude Code, `${CLAUDE_SKILL_DIR}` es la carpeta de la skill (también dentro de un plugin).

## Scripts dentro de la skill

- Mejor un script probado que pedir a Claude que escriba código cada vez: más fiable, más barato en tokens y siempre igual.
- Decir claro si el script **se ejecuta** ("Ejecuta `scripts/x.sh`") o **se lee** ("Mira `scripts/x.py` para ver el algoritmo").
- **Resolver, no delegar**: el script maneja sus errores con mensajes útiles ("Campo 'fecha' no existe. Campos disponibles: ...").
- **Sin números mágicos**: cada constante con su motivo en un comentario.
- **No suponer que algo está instalado**: decir qué instalar (`pip install pypdf`, `brew install ffmpeg`).
- Para cambios grandes o destructivos: plan en un archivo → validar el plan con un script → ejecutar → verificar.
- **Windows**: Claude Code usa Git Bash para ejecutar `bash` solo si está instalado Git for Windows; sin él usa PowerShell y un `.sh` no corre. Decirlo en los requisitos, o dar versión PowerShell del comando. En Windows `python3` a veces no existe (es `python`) o es un acceso directo de la Microsoft Store que no hace nada.

## Campos extra de Claude Code

Solo valen en Claude Code (no subir a claude.ai/API con ellos):
- `disable-model-invocation: true`: solo se lanza con `/nombre` (útil para acciones con efectos: publicar, desplegar).
- `user-invocable: false`: no sale en el menú `/`, solo la usa Claude.
- `argument-hint: [url]` y `$ARGUMENTS`, `$0`, `$1`: argumentos del comando.
- `when_to_use`: texto extra de activación (cuenta para el límite de 1.536).
- `context: fork` + `agent`: se ejecuta en un subagente.
- `paths`: solo se activa sola con archivos que cumplan esos patrones.
- `` !`comando` ``: ejecuta un comando antes de que Claude lea la skill y mete su salida. Si el comando falla, la skill entera se aborta (añadir `|| true` si puede fallar).

## Dónde vive la skill

| Sitio | Carpeta | Para quién |
|---|---|---|
| Personal | `~/.claude/skills/<nombre>/SKILL.md` | Tú, en todos tus proyectos de ese ordenador |
| Proyecto | `.claude/skills/<nombre>/SKILL.md` dentro del repo | Todo el que abra ese repo con Claude Code |
| Plugin | `<plugin>/skills/<nombre>/SKILL.md` | Quien instale el plugin; se llama `/plugin:nombre` |

- Si dos coinciden de nombre: empresa > personal > proyecto. Las de plugin no chocan porque llevan prefijo.
- Claude Code detecta solo los cambios en SKILL.md de carpetas que ya existían al abrir la sesión. Si se creó la carpeta `skills/` nueva, usar `/reload-skills` (o abrir sesión nueva).
- Para compartir con otras personas: plugin + marketplace en un repo de GitHub (skill **crear-repos**).

## Errores típicos

- El `---` inicial no está en la primera línea → la skill carga sin campos.
- Nombre de campo mal escrito → se ignora en silencio.
- `name` con mayúsculas o distinto de la carpeta → falla en claude.ai/API.
- Rutas absolutas de tu ordenador (`/Users/tu-nombre/...`) → no funciona en otro equipo y filtra tu nombre.
- Description vaga o en primera persona → no se activa.
- Todo en un SKILL.md de 2.000 líneas → gasta contexto y Claude lee a medias.
- Enlace a `references/x.md` que no existe → Claude busca a ciegas.

## Checklist antes de compartir

- [ ] Description concreta, en tercera persona, con qué hace y cuándo
- [ ] `name` válido e igual que la carpeta
- [ ] Cuerpo < 500 líneas; detalle en archivos enlazados a un nivel
- [ ] Sin información que caduque; términos consistentes; ejemplos concretos
- [ ] Scripts que manejan errores, constantes explicadas, dependencias dichas
- [ ] Rutas con `/` y sin rutas personales
- [ ] Pasos de validación en lo crítico
- [ ] 3+ casos de prueba y probada con uso real (ver probar.md)
