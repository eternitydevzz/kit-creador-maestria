---
name: crear-repos
description: Crea proyectos completos en un repositorio de GitHub a partir de lo que pida el usuario - una app local con interfaz, un plugin de skills de Claude o un motor de scripts - con la estructura Maestría (README con portada, CLAUDE.md que hace de manual para Claude, INSTALAR.md, instaladores para Mac y Windows, datos del usuario fuera de git), revisión de secretos y datos personales, publicación con permiso y prueba de instalación desde cero. Puede construir el proyecto entero desde la idea o solo montar la estructura sobre lo que el usuario ya tiene. Úsala siempre que el usuario diga "crear repo", "nuevo repositorio", "nuevo proyecto", "quiero una herramienta que...", "quiero una app que...", "subir a GitHub", "publicar mi proyecto", "compartirlo con el equipo o con alumnos", "convertir esto en un repo", "README profesional", "instalador para Mac y Windows", "revisa mi repo antes de publicar" o "convertir mis skills en plugin".
---

# Crear repos

Objetivo: que cualquiera abra el repo, entienda en 10 segundos qué es, lo instale en Mac o Windows con un comando (o diciéndole a Claude *"instálame esto"*) y no encuentre ni un secreto ni un dato personal.

Detalle en archivos aparte (leer solo el que toque):
- Estructura de cada tipo (app local, plugin de skills, motor de scripts) → [references/tipos.md](references/tipos.md)
- Construir el proyecto desde la idea (modo construir) → [references/construir.md](references/construir.md)
- Plugin y marketplace de Claude Code → [references/plugins.md](references/plugins.md)
- README con portada → [references/readme.md](references/readme.md)
- LICENSE, CHANGELOG, versiones, topics, límites de tamaño → [references/archivos-repo.md](references/archivos-repo.md)
- Secretos y datos personales → [references/seguridad.md](references/seguridad.md)
- Fuentes → [references/fuentes.md](references/fuentes.md)

Plantillas en `assets/`: `plantilla-README.md`, `plantilla-CLAUDE.md`, `plantilla-INSTALAR.md`, `instaladores/mac/` e `instaladores/windows/`, `gitignore-base`, `gitattributes-base`, `marketplace.json`, `plugin.json`. Revisión automática: `scripts/revisar_repo.sh`.

Las skills que vayan dentro del proyecto se escriben con la skill **crear-skills** (si está instalada).

## Progreso

Copiar esta lista en la respuesta e ir marcando:

```
- [ ] 0. Preguntas
- [ ] 1. Plan aprobado por el usuario
- [ ] 2. Construir (solo modo construir) o reunir lo que ya tiene
- [ ] 3. Estructura Maestría
- [ ] 4. Instaladores Mac y Windows
- [ ] 5. README, CLAUDE.md, INSTALAR.md, LICENSE, CHANGELOG
- [ ] 6. Revisión automática + prueba de instalación en local
- [ ] 7. Crear el repo en GitHub (con permiso del usuario)
- [ ] 8. Ajustes en GitHub
- [ ] 9. Prueba de instalación desde cero
- [ ] 10. Informe final
```

## Paso 0: preguntas

Preguntar solo lo que no se sepa ya, todo de una vez y con opciones concretas:
1. **Qué quiere hacer**, en una frase, y **un ejemplo real** de lo que entra y de lo que debe salir.
2. **Modo**:
   - **Construir**: Claude hace la herramienta desde la idea y la deja como repo.
   - **Estructura**: el usuario ya tiene su código o sus skills; Claude monta el repo alrededor.
3. **Tipo** (si no está claro, proponer uno y explicar por qué): **app local** con interfaz en el navegador, **plugin de skills** de Claude, o **motor de scripts** sin interfaz. Ver [references/tipos.md](references/tipos.md).
4. **Privado o público.** Privado = equipo; público = cualquiera (necesita LICENSE y más cuidado con lo que sale). Si es público, **titular de la licencia**.
5. **Cuenta u organización** de GitHub. Comprobar con `gh auth status` con qué cuenta está conectado; si no es esa, avisar (se cambia con `gh auth switch`).
6. **Quién lo instala y en qué sistema** (Mac, Windows, los dos) y qué cuentas o claves necesita cada persona.
7. **Nombre del repo**: minúsculas y guiones, corto y que diga lo que hace (`carrusel-creator-pro`, no `mis-cosas`). Si quiere un nombre con espacios o tildes, va en el título del README y en `displayName`; el repo no los admite.
8. **Qué NO puede salir**: nombres, emails, fotos, clientes, material con derechos.

## Paso 1: plan

Proponer un plan simple: tipo, estructura de carpetas, qué hace cada pieza, qué instala el instalador y, en modo construir, las fases. Decir qué puede hacerlo lento o difícil de instalar. Esperar el sí del usuario antes de crear nada, y decirle qué `.md` se van a crear y para qué.

## Paso 2: construir o reunir

- **Modo construir**: seguir [references/construir.md](references/construir.md). Lo primero, una pasada de punta a punta con su ejemplo real que el usuario ve antes de seguir. Después, una fase cada vez.
- **Modo estructura**: copiar a una carpeta nueva y limpia solo lo que entra. Nunca publicar la carpeta de trabajo diaria tal cual: ahí suele haber borradores, claves, datos de clientes y archivos personales.

## Paso 3: estructura Maestría

Montar las carpetas del tipo elegido según [references/tipos.md](references/tipos.md). En todos:
- `.gitignore` ← `assets/gitignore-base`, añadiendo la carpeta de datos (`datos/` y `!datos/.gitkeep`).
- `.gitattributes` ← `assets/gitattributes-base` (los `.cmd`/`.ps1` con CRLF y los `.sh` con LF; si no, fallan en el otro sistema).
- `docs/img/` para la portada y las capturas.
- Tipo plugin: `.claude-plugin/` ← `assets/marketplace.json` y `assets/plugin.json`, con el mismo `name` en los dos.

## Paso 4: instaladores Mac y Windows

Copiar `assets/instaladores/mac/` a `mac/` y `assets/instaladores/windows/` a `windows/`, y rellenar el bloque **AJUSTES** del principio de cada script (nombre, tipo, origen, programas). Añadir lo propio del proyecto (descargas, comprobación final) como pasos nuevos, siguiendo el mismo estilo.

- Se pueden repetir sin romper nada: lo que ya está se salta.
- Lo que necesita a la persona (contraseña, iniciar sesión, una clave) no lo hace el script: lo pide INSTALAR.md.
- Los `.ps1` se guardan en UTF-8 **con BOM** (las plantillas ya lo llevan): sin él, el PowerShell de Windows lee mal las tildes.
- Tipo app: añadir `arrancar.sh` y `arrancar.cmd`/`.ps1`, que abren la app y esperan a que responda.

Comprobar al menos la sintaxis: `bash -n mac/*.sh`. Si hay PowerShell (`pwsh`), también los `.ps1`.

## Paso 5: documentos

Partir de las plantillas y rellenarlas con datos reales del proyecto (nada de "más rápido" sin medirlo):
- `README.md` ← `assets/plantilla-README.md`. Ver [references/readme.md](references/readme.md).
- `CLAUDE.md` ← `assets/plantilla-CLAUDE.md`: el manual para Claude. Saluda por el nombre usando `usuario.md`, sabe instalar el proyecto y dice dónde está cada cosa.
- `INSTALAR.md` ← `assets/plantilla-INSTALAR.md`.
- `LICENSE` si es público (MIT si no hay motivo para otra; ver [references/archivos-repo.md](references/archivos-repo.md)).
- `CHANGELOG.md` con la versión 1.0.0.

## Paso 6: revisión automática y prueba en local

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/revisar_repo.sh" "<carpeta_del_repo>" --publico --bloquear "palabra1,palabra2"
```

- `--publico` solo si va a ser público (exige LICENSE).
- `--bloquear` = palabras que no pueden aparecer (nombre real, email, clientes). Ojo con las palabras comunes: se busca sin distinguir mayúsculas.
- Revisa archivos base (README, CLAUDE.md, LICENSE, .gitignore), carpeta de datos fuera de git, archivos de más de 50/100 MiB, secretos conocidos, rutas personales, `.env`, `.DS_Store`, cada SKILL.md y los JSON del plugin.

Bucle: corregir → volver a ejecutar → seguir solo cuando salga `RESULTADO: OK`. Los avisos se leen uno por uno y se decide. Si un secreto ya estuvo en un commit, seguir [references/seguridad.md](references/seguridad.md): primero revocarlo.

Después, **ejecutar el instalador de Mac** en el propio proyecto (o el de Windows si se está en Windows) y comprobar que termina en "Hecho". Tipo plugin: con `--local`, y ver en `claude plugin details` que salen todas las skills.

## Paso 7: crear el repo en GitHub

Publicar es hacia fuera y en un repo público no tiene vuelta atrás (puede copiarse en minutos): **mostrar al usuario cuenta, nombre, visibilidad, lista de archivos y con qué nombre y email se firmarán los commits, y esperar su sí.** Mirar `git config user.name` y `user.email`: si es su nombre real y el repo es público, ofrecer el email privado de GitHub (`<id>+<cuenta>@users.noreply.github.com`) solo para este repo.

```bash
cd "<carpeta_del_repo>"
git init -b main
git add <archivos concretos>        # mejor que "git add ." para no colar nada
git diff --cached --stat            # revisar qué entra
git commit -m "feat: primera versión"
gh repo create <cuenta>/<nombre> --private --source=. --push --description "<una frase>"
```

`--public` en vez de `--private` si es público.

## Paso 8: ajustes en GitHub

```bash
gh repo edit <cuenta>/<nombre> --add-topic claude-code --add-topic <tema>
gh repo edit <cuenta>/<nombre> --enable-secret-scanning --enable-secret-scanning-push-protection
git tag v1.0.0 && git push origin v1.0.0
gh release create v1.0.0 --title "v1.0.0" --notes "<qué trae, en una frase>"
```

- Topics: máx. 20, minúsculas/números/guiones, máx. 50 caracteres cada uno.
- El escaneo de secretos puede no estar disponible en repos privados según el plan; si falla, avisar y no insistir.
- Si se cambió de cuenta con `gh auth switch`, volver a la de siempre al terminar.

## Paso 9: prueba de instalación desde cero

Como si fuera un usuario nuevo (nunca dar por bueno sin esto):
- `gh repo clone <cuenta>/<nombre>` en una carpeta temporal y seguir INSTALAR.md al pie de la letra. Cada paso que falle o falte se arregla en INSTALAR.md.
- Tipo plugin: `/plugin marketplace add <cuenta>/<nombre>` y `/plugin install <plugin>@<marketplace>`; sesión nueva y una frase real.
- Si no se pudo probar en Windows, decirlo claro: "no probado en Windows".

## Paso 10: informe final

Lo malo primero:
- Qué falló o quedó pendiente, qué no se probó (sistema, datos reales, instalación desde cero).
- Salida del script de revisión (OK, avisos que se dejaron y por qué).
- Enlace al repo, cómo se instala y versión publicada.
- Mejoras posibles y una nota del 1 al 10 con el motivo.

## Mantener el repo

- Cada cambio que deba llegar a los usuarios sube la versión (en plugins, `version` de `plugin.json`; si no, nadie lo recibe) y se apunta en CHANGELOG.md.
- Versiones: MAJOR rompe algo, MINOR añade sin romper, PATCH arregla.
- Renombrar un repo: GitHub redirige el nombre viejo. Renombrar un plugin rompe instalaciones: ver `renames` en [references/plugins.md](references/plugins.md).
