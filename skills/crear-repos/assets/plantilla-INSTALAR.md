<!-- Plantilla Maestría. Cambiar todo lo que está entre < > y borrar lo que no aplique. -->

# Instalar <Nombre del proyecto>

Tarda unos <N> minutos. **Lo más fácil:** abre Claude Code en esta carpeta y dile *"instálame esto"*; te irá diciendo lo que tienes que hacer tú.

## Contenido
- Antes de empezar
- Mac
- Windows
- Comprobar
- Actualizar
- Dónde queda cada cosa
- Problemas frecuentes

## Antes de empezar

Esto lo haces tú, una sola vez:

1. **Claude Code** instalado y con tu cuenta iniciada: https://code.claude.com/docs/en/setup
2. **Herramientas base**
   - Mac: Homebrew (te pedirá la contraseña del Mac): https://brew.sh
   - Windows: **Git for Windows** (obligatorio: sin él Claude Code no puede ejecutar los scripts): https://git-scm.com/downloads/win
3. **Bajar el proyecto.** En una terminal:

   ```bash
   gh repo clone <cuenta>/<nombre-repo>
   ```

   <!-- Si es privado: antes, aceptar la invitación de GitHub y hacer "gh auth login". -->
4. **<Cuenta o clave de servicio>** (opcional / obligatoria). **Escríbela tú, nunca en el chat de Claude.** Mac:

   ```bash
   open -e <carpeta de datos>/.env
   ```

   Windows:

   ```powershell
   notepad <carpeta de datos>\.env
   ```

   y escribe una línea `<NOMBRE_CLAVE>=tu-clave`.

## Mac

En la terminal, dentro de la carpeta del proyecto:

```bash
bash mac/instalar.sh
```

Se puede repetir: lo que ya está hecho se salta.

## Windows

Doble clic en `windows\instalar.cmd`, o en una terminal dentro de la carpeta del proyecto:

```powershell
windows\instalar.cmd
```

Si Windows pregunta si confías en el script, responde que sí: el `.cmd` lo lanza solo para esta vez, sin cambiar la configuración de Windows.

## Comprobar

<Qué hacer para ver que va: una frase en Claude Code, abrir la app, o un comando de prueba que no gasta nada.>

## Actualizar

Mac:

```bash
bash mac/actualizar.sh
```

Windows: `windows\actualizar.cmd`. Después abre una sesión nueva de Claude Code.

## Dónde queda cada cosa

| Qué | Dónde |
|---|---|
| El proyecto | la carpeta que bajaste |
| Lo tuyo (resultados, `usuario.md`, claves) | `<carpeta de datos>` (nunca se sube a GitHub) |

## Problemas frecuentes

- **<Síntoma real que salió en la prueba>**: <solución>.
- **En Windows dice que no encuentra `bash`**: instala Git for Windows y vuelve a abrir la terminal.
