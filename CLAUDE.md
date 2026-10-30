# Kit Creador Maestría · manual para Claude

Plugin de Claude Code con dos skills: **crear-skills** (crear, mejorar y probar skills) y **crear-repos** (crear proyectos completos en GitHub: app local, plugin de skills o motor de scripts, con la estructura Maestría e instaladores para Mac y Windows).

**Habla siempre en español**, claro y sencillo.

## Si te piden «instálame esto»

1. Comprueba que Claude Code está instalado. En Windows, que está **Git for Windows** (sin él no corren los scripts `bash` de revisión).
2. Para publicar en GitHub hace falta **GitHub CLI** con sesión iniciada: pide a la persona que ejecute ella `gh auth login` (abre el navegador y es su cuenta).
3. Dile que escriba en Claude Code estos dos comandos, uno detrás de otro:

   ```
   /plugin marketplace add eternitydevzz/kit-creador-maestria
   ```

   ```
   /plugin install kit-creador-maestria@kit-creador-maestria
   ```

4. Termina pidiéndole que abra una sesión nueva y diga, por ejemplo, *"Crea una skill para ..."* o *"Quiero una herramienta que ..."*.

## Dónde está cada cosa

- `.claude-plugin/`: `plugin.json` (nombre, versión) y `marketplace.json` (catálogo). El `name` del plugin es igual en los dos.
- `skills/crear-skills/`: SKILL.md, `references/` (escribir, probar, fuentes), `assets/plantilla-SKILL.md` y `scripts/revisar_skill.sh`.
- `skills/crear-repos/`: SKILL.md, `references/` (tipos, construir, plugins, readme, archivos-repo, seguridad, fuentes), `assets/` (plantillas de README, CLAUDE.md, INSTALAR.md, instaladores Mac y Windows, `.gitignore`, `.gitattributes`, JSON del plugin) y `scripts/revisar_repo.sh`.
- Los archivos de `assets/` son **plantillas a propósito**: llevan `<...>` para rellenar. No los rellenes aquí.

## Reglas para trabajar aquí

- **Antes de cada versión**, las dos revisiones tienen que dar `RESULTADO: OK`:

  ```bash
  bash skills/crear-repos/scripts/revisar_repo.sh . --publico --bloquear "<nombres y emails que no pueden salir>"
  ```

  ```bash
  bash skills/crear-skills/scripts/revisar_skill.sh skills
  ```

- **Versiones:** cada cambio que deba llegar a los alumnos sube `version` en `.claude-plugin/plugin.json` (si no, nadie lo recibe), la insignia de versión del README y una entrada en `CHANGELOG.md`.
- **Finales de línea:** `.sh` con LF y `.cmd`/`.ps1` con CRLF (lo fija `.gitattributes`). Los `.ps1` en UTF-8 **con BOM**: sin él, el PowerShell de Windows lee mal las tildes.
- **Un solo código para Mac y Windows**: los scripts funcionan en bash 3.2 (el del Mac) y en Git Bash. Nada de herramientas que solo hay en el Mac.
- **Nada personal en el repo**: ni nombres, ni emails, ni rutas de un ordenador, ni claves. Los ejemplos de ruta son genéricos (`/Users/nombre/`).
- Cada dato de Claude Code o GitHub que se añada a las skills sale de la documentación oficial y se apunta en el `references/fuentes.md` de la skill.

## Lo que no hay que hacer

- Cambiar el `name` del plugin o del marketplace: rompe las instalaciones de los alumnos (si hace falta, `renames` en `marketplace.json`; ver `skills/crear-repos/references/plugins.md`).
- Publicar o subir cambios sin el sí del dueño del repo.
- Decir que algo funciona en Windows sin haberlo probado allí: los instaladores de Windows no se han probado en un Windows real.
