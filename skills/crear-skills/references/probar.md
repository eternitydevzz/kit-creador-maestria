# Probar una skill

## Contenido
- Por qué probar
- 1. Línea base: la tarea sin skill
- 2. Casos de prueba
- 3. Prueba de activación (la description)
- 4. Prueba de uso real en sesión nueva
- 5. Qué observar
- Formato de un caso de prueba

## Por qué probar

Una skill que no se activa no sirve, y una que se activa pero hace algo distinto a lo esperado es peor. Escribirla "a ojo" no dice si funciona: solo probarla con frases reales lo dice.

## 1. Línea base: la tarea sin skill

Antes de escribir (o al revisar una existente), hacer la tarea con Claude **sin** la skill y apuntar en qué falla: qué pregunta de más, qué se inventa, qué olvida, qué formato saca mal. La skill existe para tapar exactamente esos fallos. Lo que Claude ya hace bien no hace falta escribirlo.

## 2. Casos de prueba

Al menos **3 casos** que cubran los fallos del punto 1. Cada caso: la frase que diría el usuario, los archivos que usaría y lo que debe pasar (comprobable: "pregunta la cuenta antes de publicar", no "lo hace bien").

Guardarlos en `evals/casos.json` dentro de la carpeta de trabajo de la skill (no hace falta subirlos con ella).

## 3. Prueba de activación (la description)

Unas 10–20 frases:
- La mitad **deben** activarla: dichas como las diría alguien de verdad, con sinónimos y sin usar el nombre de la skill.
- La otra mitad **no deben** activarla: parecidas, con vocabulario cercano, pero que son trabajo de otra skill o de ninguna.

En una sesión nueva, escribir cada frase y mirar si Claude carga la skill. Si no se activa con una frase que debería, añadir esas palabras a la description. Si se activa con una que no debería, decir en la description para qué NO es.

Normal: tareas de un solo paso muy simples a veces no la activan aunque coincidan.

## 4. Prueba de uso real en sesión nueva

Método "Claude A / Claude B":
- **Claude A** (esta sesión) ayuda a escribir la skill.
- **Claude B** (una sesión nueva, sin el contexto de esta conversación) la usa en una tarea real con datos reales.
- Lo que falle en B se corrige con A y se vuelve a probar en otra sesión nueva.

La sesión nueva importa: en la sesión donde se escribió, Claude ya sabe lo que la skill quiere decir y rellena huecos que en otra persona fallarían.

Probar con los modelos que se vayan a usar: un modelo pequeño necesita más guía; uno grande se aburre con lo obvio.

## 5. Qué observar

- Archivos de `references/` que Claude nunca abre → sobran o están mal enlazados.
- Archivos que abre siempre → quizá su contenido va en SKILL.md.
- Pasos que se salta → no están claros, o no explican por qué importan.
- Preguntas que hace y no debería (o al revés).
- En plugins: `claude plugin eval` compara con y sin plugin.

## Formato de un caso de prueba

```json
{
  "skills": ["crear-repos"],
  "query": "Sube mis 3 skills de vídeo a un repo privado para el equipo",
  "files": [],
  "expected_behavior": [
    "Pregunta cuenta, visibilidad y qué no puede salir",
    "Ejecuta revisar_repo.sh y corrige hasta RESULTADO: OK",
    "Pide permiso antes de gh repo create"
  ]
}
```
