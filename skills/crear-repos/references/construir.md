# Construir el proyecto entero (modo "construir")

## Contenido
- Cuándo se usa
- 1. Entender qué quiere
- 2. Plan simple por fases
- 3. Pasada de punta a punta con datos reales
- 4. Una fase cada vez
- 5. Cuando algo falla
- 6. Cerrar el proyecto

## Cuándo se usa

Cuando el usuario elige que Claude construya su herramienta desde la idea. Si ya tiene el código o las skills hechas, se usa el modo "estructura" y este archivo no hace falta.

## 1. Entender qué quiere

Antes de escribir nada, tener claro:
- Qué hace, en una frase ("convierte un link de Instagram en un carrusel con mi marca").
- Un ejemplo real de entrada y de resultado bueno (un archivo, un link, una captura).
- Qué cuentas o servicios necesita (Claude, ChatGPT/Codex, una API con clave) y quién paga cada uno.
- Qué no debe hacer nunca (publicar solo, borrar archivos, gastar créditos sin avisar).

Si falta algo de esto, preguntarlo. Sin ejemplo real no hay forma de saber si funciona.

## 2. Plan simple por fases

Escribir un plan corto y enseñarlo al usuario antes de empezar:
- Fases pequeñas, cada una con algo que se puede ver o probar.
- La fase 1 siempre es la pasada de punta a punta.
- Lo opcional, al final y marcado como opcional.
- Si algo hace el proyecto lento o difícil de instalar (una dependencia pesada, una cuenta de pago), decirlo aquí.

Si el plan necesita un archivo (`PLAN.md`), preguntar antes de crearlo. Se puede quitar del repo antes de publicar.

## 3. Pasada de punta a punta con datos reales

Lo primero que se construye es la versión más simple que va de la entrada al resultado con el ejemplo real del usuario. Fea y mínima, pero completa. El usuario la ve y la valida antes de construir nada más.

Por qué: así se descubre pronto si la idea funciona, si una API falla o si el resultado no es lo que quería, antes de pulir algo que habrá que tirar.

## 4. Una fase cada vez

- Seguir el plan en orden y comprobar cada fase antes de pasar a la siguiente.
- Probar con datos reales, no inventados. Decir siempre qué se probó y qué no.
- Si a mitad surge algo nuevo (una idea, un fallo), apuntarlo y preguntar si se arregla ya o después.
- Para lo que deba salir siempre igual, un script probado; para lo que necesita criterio, instrucciones en CLAUDE.md o en una skill (skill **crear-skills**).

## 5. Cuando algo falla

- Decirlo en cuanto se sabe, con el error real (lo que imprimió el comando).
- Proponer el arreglo y preguntar antes de cambiar el plan.
- No esconder fallos con valores por defecto que "funcionan" pero dan un resultado falso.

## 6. Cerrar el proyecto

Cuando todas las fases pasan, se sigue con el resto de la skill: estructura Maestría, instaladores, README, revisión, publicación con permiso y prueba desde cero.
