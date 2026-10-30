<!-- Plantilla Maestría. Cambiar todo lo que está entre < > y borrar lo que no aplique. Claude Code lee este archivo solo al abrir la carpeta. -->

# <Nombre del proyecto> · manual para Claude

<Qué es en una o dos frases: tipo (app local / plugin de skills / motor de scripts), qué hace y qué pieza hace cada cosa.>

**Habla siempre en español**, claro y sencillo.

## Al empezar cada conversación

1. Lee **`<carpeta de datos>/usuario.md`** y llama al usuario por su nombre.
2. Si no existe (recién instalado), pregúntale cómo se llama y créalo con esta forma:

   ```markdown
   # Usuario
   nombre: <su nombre>

   ## Gustos
   - <lo que le gusta o no, en cuanto lo diga>

   ## Cambios que ha pedido
   - <fecha> · <qué pidió cambiar>
   ```

3. Cada vez que diga algo que le gusta o no le gusta, o pida un cambio, apúntalo ahí en el momento. `<carpeta de datos>` es suya: nunca se sube a git.

## Si te piden «instálame esto»

1. Lee [INSTALAR.md](INSTALAR.md) y mira si es Mac o Windows.
2. Comprueba «Antes de empezar» y **pide a la persona** lo que solo puede hacer ella: instalar Homebrew (pide su contraseña), Git for Windows, `gh auth login`, iniciar sesión en <servicio>.
3. **Las claves nunca se escriben en el chat.** Dale el comando que abre el archivo `<carpeta de datos>/.env` y que la escriba ella.
4. Ejecuta el instalador (`bash mac/instalar.sh` o `windows\instalar.cmd`) y cuenta lo que imprime. Si falla, di en qué paso y qué quedó hecho.
5. Termina diciéndole cómo empezar: <frase, comando o cómo arrancar la app>.

## Cómo funciona

| Paso | Quién | Qué pasa |
|---|---|---|
| <Entrada> | El usuario | <qué pone> |
| <Paso> | Claude / el motor | <qué hace> |
| <Resultado> | <quién> | <qué sale y dónde se guarda> |

## Antes de empezar una tarea, pregunta

Solo lo que no sepas ya (míralo antes en `usuario.md`):
1. <pregunta 1>
2. <pregunta 2>

## Dónde está cada cosa

- `<carpeta>/`: <qué hay>.
- Lo de cada usuario vive en `<carpeta de datos>` (fuera de git).
- Resultados: `<ruta>` (si los dejas en otro sitio, el usuario no los encuentra).

## Reglas para trabajar aquí

- **Un solo código para Mac y Windows.** Rutas con `/`; en Windows los comandos van por Git Bash. Nada de herramientas que solo hay en el Mac sin su alternativa para Windows.
- **Nada personal en el repo**: ni nombres, ni emails, ni rutas de un ordenador, ni claves. Antes de cada versión, `revisar_repo.sh` de la skill crear-repos.
- **Versiones:** cada cambio que deba llegar a los usuarios sube la versión (y se apunta en CHANGELOG.md).
- <regla propia del proyecto, con su porqué>

## Lo que no hay que hacer

- <cosa que rompe algo o que el usuario no quiere, con el motivo>
