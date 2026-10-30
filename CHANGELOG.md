# Cambios

Lo nuevo arriba. Versiones: MAJOR rompe algo, MINOR añade sin romper, PATCH arregla.

## 1.1.0 - 2026-10-30

### Cambiado
- `crear-repos` crea proyectos completos a partir de lo que pide el usuario, no solo repos de skills. Pregunta el modo (construir el proyecto entero o solo montar la estructura) y el tipo (app local, plugin de skills o motor de scripts).

### Añadido
- Estructura Maestría por tipo (`references/tipos.md`) y guía para construir por fases (`references/construir.md`).
- Plantillas de `CLAUDE.md`, `INSTALAR.md`, `.gitattributes` e instaladores para Mac (`instalar.sh`, `actualizar.sh`) y Windows (`instalar.cmd`/`.ps1`, `actualizar.cmd`/`.ps1`).
- README con las secciones de los proyectos Maestría.
- `CLAUDE.md` del kit: manual para Claude (instalar, dónde está cada cosa y reglas antes de cada versión).
- `revisar_repo.sh` avisa si falta `CLAUDE.md`, si `datos/` no está en `.gitignore`, si un `.sh` tiene finales de Windows o si un `.ps1` con tildes no lleva BOM.

## 1.0.0 - 2026-10-30

### Añadido
- Skill `crear-skills`: crear, mejorar y probar skills, con el script `revisar_skill.sh`.
- Skill `crear-repos`: preparar y publicar repos de GitHub como plugin + marketplace, con el script `revisar_repo.sh`.
