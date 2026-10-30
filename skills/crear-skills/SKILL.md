---
name: crear-skills
description: Crea, mejora y prueba skills de Claude (carpetas con SKILL.md) según la norma Agent Skills y Claude Code - preguntas iniciales, prueba sin skill, nombre y description que se activan bien, cuerpo corto con pasos, scripts y archivos de apoyo, revisión automática con script, prueba de activación con frases reales, prueba de uso en sesión nueva y dónde instalarla. Úsala siempre que el usuario diga "crear una skill", "hacer una skill", "nueva skill", "convertir esto en skill", "skill para ...", "mejorar mi skill", "revisar mi skill", "mi skill no se activa", "escribir un SKILL.md", "description de la skill" o quiera que Claude haga siempre una tarea de la misma forma. Para publicar skills en GitHub o compartirlas como plugin, usar crear-repos.
---

# Crear skills

Objetivo: una skill que Claude activa cuando toca, que hace la tarea igual de bien cada vez y que funciona en el ordenador de otra persona.

Detalle en archivos aparte (leer solo el que toque):
- Reglas para escribir (frontmatter, description, cuerpo, scripts, Windows, dónde vive) → [references/escribir.md](references/escribir.md)
- Cómo probarla (línea base, casos, activación, sesión nueva) → [references/probar.md](references/probar.md)
- Fuentes → [references/fuentes.md](references/fuentes.md)

Plantilla: `assets/plantilla-SKILL.md`. Revisión automática: `scripts/revisar_skill.sh`.

## Progreso

Copiar esta lista en la respuesta e ir marcando:

```
- [ ] 0. Preguntas
- [ ] 1. Línea base (la tarea sin skill)
- [ ] 2. Nombre y description
- [ ] 3. Cuerpo
- [ ] 4. Scripts y archivos de apoyo
- [ ] 5. Revisión automática sin errores
- [ ] 6. Pruebas (activación + sesión nueva)
- [ ] 7. Instalar o compartir
- [ ] 8. Informe final
```

**Mejorar una skill que ya existe:** leerla entera, pasar primero el paso 5 para ver qué falla, preguntar al usuario qué le molesta de cómo funciona hoy y seguir desde el paso que toque.

## Paso 0: preguntas

Antes, mirar si ya hay una skill parecida (`ls ~/.claude/skills` y `.claude/skills` del proyecto): mejor mejorar esa que tener dos que se pisan.

Preguntar solo lo que no se sepa ya, todo de una vez:
1. **Qué tarea** hace y **qué resultado** espera el usuario (formato, dónde se guarda).
2. **Un ejemplo real**: la entrada (archivo, enlace, texto) y cómo sería un resultado bueno. Sin ejemplo real no hay forma de probarla.
3. **Qué frases diría** para pedirla.
4. **Dónde se usa**: solo él (personal), en un proyecto, o compartida con otros (plugin). Y en qué sistema (Mac, Windows) y si también en claude.ai.
5. **Qué herramientas necesita** (ffmpeg, Python, una API con clave) y qué no debe hacer nunca sin permiso (publicar, enviar, borrar).

## Paso 1: línea base

Hacer la tarea una vez sin skill (o recordar cómo salió) y apuntar los fallos: qué preguntó de más, qué inventó, qué olvidó. La skill se escribe para tapar esos fallos; lo que Claude ya hace bien no se escribe. Ver [references/probar.md](references/probar.md).

## Paso 2: nombre y description

- `name`: minúsculas y guiones, forma de acción (`adaptar-fotos`), igual que la carpeta, sin `claude` ni `anthropic`.
- `description`: tercera persona, qué hace con verbos concretos + "Úsala siempre que el usuario diga ..." con 5–10 frases reales del paso 0. Máx. 1.024 caracteres, lo importante al principio.
- Si hay otra skill parecida, decir en cada una para qué NO es.

Es lo que más importa: Claude decide si usar la skill leyendo solo esto. Reglas y ejemplos en [references/escribir.md](references/escribir.md).

## Paso 3: cuerpo

Partir de `assets/plantilla-SKILL.md`:
- Objetivo en una o dos frases, lista de progreso y pasos numerados.
- Solo lo que Claude no sabe: las reglas del usuario, sus rutas, sus decisiones, sus números.
- El porqué de cada regla en una frase, en vez de mayúsculas.
- Comando exacto donde un error rompe algo; criterios donde hay muchas formas válidas.
- Un paso de comprobación antes de entregar y pedir permiso antes de lo que no tiene vuelta atrás.
- Menos de 500 líneas. Lo largo va a `references/`.

## Paso 4: scripts y archivos de apoyo

- `references/`: un archivo por tema, enlazado directo desde SKILL.md; índice si pasa de 100 líneas.
- `scripts/`: para lo que debe salir siempre igual. Rutas con `${CLAUDE_SKILL_DIR}/scripts/...`, errores con mensajes útiles y dependencias dichas.
- `assets/`: plantillas, imágenes, datos.
- Si la usan en Windows: Git for Windows en los requisitos y comandos que funcionen en Git Bash.
- Crear cualquier `.md` nuevo solo después de decir al usuario cuál y para qué.

## Paso 5: revisión automática

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/revisar_skill.sh" "<carpeta_de_la_skill>"
```

Revisa frontmatter, `name`, longitud y forma de la description, tamaño del cuerpo, rutas con `\`, rutas personales, enlaces rotos y archivos de `references/` sin mencionar. También vale con una carpeta que tenga varias skills dentro.

Bucle: corregir → volver a ejecutar → seguir solo cuando salga `RESULTADO: OK`. Los avisos se leen uno por uno y se decide (un aviso de ruta en un ejemplo genérico se puede dejar).

## Paso 6: pruebas

1. **Activación**: 10–20 frases, la mitad deben activarla y la mitad no (parecidas pero de otra cosa). Ajustar la description hasta que acierte.
2. **Uso real en sesión nueva**: el usuario abre una sesión nueva y pide la tarea con el ejemplo real del paso 0. Lo que falle se corrige aquí y se repite.

Proponer las frases y el ejemplo al usuario y pedirle que haga la prueba en la sesión nueva (o que comparta cómo salió). Sin esto, la skill no está probada y hay que decirlo así. Detalle en [references/probar.md](references/probar.md).

## Paso 7: instalar o compartir

- Personal: copiar la carpeta a `~/.claude/skills/<nombre>/`.
- Proyecto: `.claude/skills/<nombre>/` dentro del repo.
- Para otras personas (equipo, alumnos): plugin + marketplace en GitHub → usar la skill **crear-repos**.
- Si se creó la carpeta `skills/` en esta sesión, usar `/reload-skills` o abrir sesión nueva para que aparezca.

## Paso 8: informe final

Lo malo primero:
- Qué no se probó (activación, sesión nueva, Windows, datos reales).
- Salida de `revisar_skill.sh` y avisos que se dejaron, con el motivo.
- Dónde quedó la skill y la frase exacta para usarla.
- Mejoras posibles y una nota del 1 al 10 con el motivo.
