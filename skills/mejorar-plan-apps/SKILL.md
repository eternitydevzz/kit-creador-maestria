---
name: mejorar-plan-apps
description: Revisa y mejora el plan de una app que ya existe (PLAN.md, plan.md, SPEC.md o similar). Lo cruza con la realidad del proyecto (git, archivos, tests, guías), le pone nota con una rúbrica de 11 criterios, entrega un informe con lo malo primero y, solo con el OK del usuario, lo reescribe guardando antes una copia del original. Úsala siempre que el usuario diga "mejorar el plan", "revisa el plan", "mejora-plan", "actualiza el plan", "el plan está desordenado", "ponle nota al plan", "¿está bien este plan?", "limpia el plan" o pase un plan.md para revisarlo. No es para crear un plan desde cero (para eso, crear-plan-apps).
---

# Mejorar plan de apps

Objetivo: que el plan vuelva a ser la fuente de verdad del proyecto, comprobado con datos reales, claro, corto y con las decisiones pendientes a la vista, sin perder nada de lo que el usuario decidió.

## Progreso

Copiar esta lista en la respuesta e ir marcando:

```
- [ ] 1. Encontrar el plan y lo que depende de él
- [ ] 2. Leerlo entero
- [ ] 3. Cruzarlo con la realidad
- [ ] 4. Ponerle nota con la rúbrica
- [ ] 5. Informe y preguntar qué se arregla
- [ ] 6. Copia del original y reescribir (solo con OK)
- [ ] 7. Comprobar que no se perdió nada
- [ ] 8. Entregar
```

## Reglas que valen en todos los pasos

- **Pasos 1-5 solo leen.** No se cambia ningún archivo, no se escribe en la base de datos y no se publica nada hasta el OK del paso 5. El usuario tiene que ver el informe antes de cualquier cambio.
- **No reabrir decisiones del usuario.** Si una decisión suya parece mala, decirlo una vez en el informe («esto va contra lo que decidiste; ¿lo mantengo?») y respetar la respuesta.
- **Cada fallo con su prueba**: qué comando, archivo o línea lo demuestra. Si no se pudo comprobar, poner «sin comprobar».
- **Sin subagentes y sin procesos pesados en paralelo.** Tests largos, uno cada vez y avisando antes.

## Paso 1: encontrar el plan y lo que depende de él

- Si el usuario no da la ruta, buscar `plan*.md`, `PLAN*.md`, `SPEC*.md` en la carpeta del proyecto (sin `node_modules`). Si hay varios, preguntar cuál.
- Buscar también lo que el plan nombra o de lo que depende: SPEC, historiales (`plan-historial-*.md`), guías (`GUIA-*.md`, `Arreglar-*.md`), `CLAUDE.md`, README.

## Paso 2: leerlo entero

Leer el plan completo, no a trozos sueltos. Apuntar: objetivo, definición de «terminado», fases y su estado, decisiones del usuario, criterios puestos por Claude, dudas abiertas, riesgos, referencias internas («sección X»).

## Paso 3: cruzarlo con la realidad

Revisar no es releer: hay que comprobar con datos. Solo lectura:

```bash
git -C "<carpeta>" status --short
git -C "<carpeta>" log --oneline -20
```

- **Lo marcado como hecho**: ¿está en el código o en git? ¿Lo marcado como pendiente ya está hecho?
- **Archivos, rutas, comandos y URLs** que nombra el plan: ¿existen? (`ls`, `test -e`; URLs con una petición GET).
- **Cifras** (número de tests, filas, usuarios): ¿coinciden con lo que hay hoy? Si contarlo exige ejecutar algo pesado, preguntar antes.
- **Guías que dependen del plan**: ¿dicen lo mismo? Buscar frases desfasadas («sin commit», «en curso», fallos ya arreglados, fechas viejas).
- Lo que no se pueda comprobar desde aquí (producción, cuentas, datos de terceros) va como «sin comprobar».

## Paso 4: nota con la rúbrica

Puntuar con [references/rubrica.md](references/rubrica.md): 11 criterios, cada uno 0, 1 o 2 con su prueba. La nota final sale de la cuenta de la rúbrica, no a ojo.

## Paso 5: informe y preguntar

Formato, lo malo primero:

1. **Si el plan no se puede usar tal como está**, eso va en la primera frase y se explica por qué.
2. **Fallos encontrados** (tabla: fallo · prueba · arreglo propuesto), los graves primero.
3. **Desfasado**: lo que el plan dice y ya no es verdad.
4. **Decisiones pendientes del usuario** que estaban escondidas en el texto.
5. **Criterios que puso Claude sin preguntar.**
6. **Nota** por criterio y total.
7. **Qué cambiaría al reescribir**, en una lista corta.

Después preguntar con AskUserQuestion: ¿reescribo con todos los arreglos, solo con algunos (cuáles), o lo dejo como está? Esperar la respuesta.

## Paso 6: copia y reescribir (solo con OK)

1. Avisar y guardar la copia del original junto al plan: `<nombre>.antes-de-mejorar-AAAA-MM-DD.md`. Si ya existe una del mismo día, añadir la hora. Es la red de seguridad para volver atrás.
2. Reescribir con la estructura de [references/estructura-plan.md](references/estructura-plan.md), conservando el contenido del usuario:
   - Decisiones del usuario: **se copian tal cual**, con sus palabras si las citó.
   - Lo hecho y comprobado sale de «lo que falta» y queda en una línea con dónde verlo (commit, historial).
   - Las fases que faltan, en orden, cada una con «cómo se comprueba».
   - Renumerar las referencias internas («sección X») y comprobar cada una.
3. Cambiar solo los arreglos aprobados. Lo que surja nuevo se apunta en «Pendiente de decidir», no se decide.

## Paso 7: comprobar que no se perdió nada

- `diff` entre la copia y el plan nuevo, leyendo cada bloque eliminado: cada decisión, pendiente, riesgo y dato del original tiene que estar en el plan nuevo o haberse quitado con permiso.
- Cada «sección X» apunta a la sección correcta.
- Volver a pasar la rúbrica: la nota tiene que subir. Si no sube, decir por qué.

## Paso 8: entregar

Lo malo primero:
- Qué no se pudo comprobar y qué fallos quedan.
- Nota antes → después, por criterio.
- Ruta del plan nuevo y de la copia.
- Lista corta de lo que cambió.
- Nota del 1 al 10 a la tarea, con el motivo.
