# Estructura Maestría por tipo de proyecto

## Contenido
- Lo común a los 3 tipos
- Tipo 1: app local
- Tipo 2: plugin de skills
- Tipo 3: motor de scripts sin app
- Datos del usuario: siempre fuera de git
- Un solo código para Mac y Windows

## Lo común a los 3 tipos

```
nombre-repo/
├── README.md        # portada y secciones fijas (assets/plantilla-README.md)
├── CLAUDE.md        # manual para Claude (assets/plantilla-CLAUDE.md)
├── INSTALAR.md      # instalación paso a paso (assets/plantilla-INSTALAR.md)
├── CHANGELOG.md     # cambios por versión
├── LICENSE          # si es público
├── .gitignore       # assets/gitignore-base + la carpeta de datos
├── docs/img/        # portada, capturas de resultados, galería
├── mac/             # instalar.sh, actualizar.sh (y arrancar.sh si hay app)
└── windows/         # instalar.cmd + .ps1, actualizar.cmd + .ps1 (y arrancar si hay app)
```

- **README.md**: es para personas (qué hace, cómo se ve, cómo se instala).
- **CLAUDE.md**: es para Claude (cómo instalarlo, dónde está cada cosa, reglas, qué no hacer). Claude Code lo lee solo al abrir la carpeta, así que el alumno puede decir *"instálame esto"* y Claude sabe qué hacer.
- **INSTALAR.md**: lo que la persona hace a mano (cuentas, Homebrew, Git for Windows, `gh auth login`) y luego el instalador.

## Tipo 1: app local

Como Carrusel Creator Pro: una interfaz que se abre en el navegador, con un motor por debajo.

```
app/          la interfaz (por ejemplo Next.js) y su API local
motor/        la lógica común: scripts, prompts, reglas (motor/REGLAS.md)
mac/          instalar.sh, arrancar.sh, actualizar.sh
windows/      instalar.cmd/.ps1, arrancar.cmd/.ps1, actualizar.cmd/.ps1
datos/        lo del usuario (fuera de git, con datos/.gitkeep)
```

- `arrancar` abre la app en el navegador y espera a que el servidor responda en vez de un tiempo fijo.
- Usar un nombre `*.localhost` (`http://mi-app.localhost:3000`): lleva al propio ordenador sin configurar nada.
- `.gitignore`: `node_modules/`, `.next/`, `datos/` y `!datos/.gitkeep`.
- README con secciones extra: "Úsala desde la app o desde Claude".

## Tipo 2: plugin de skills

Como Crear Vídeos Pro: skills de Claude que se instalan con `/plugin`, más sus recursos.

```
.claude-plugin/   marketplace.json y plugin.json (assets/)
skills/<skill>/   SKILL.md + scripts/ + references/
skills/_comun/    código que comparten varias skills (opcional)
<recursos>/       estilos, plantillas, stock... lo que usen las skills
mac/ windows/     instaladores: dependencias + "claude plugin install"
requirements.txt  si hay Python
```

- Los datos del usuario van a `~/<nombre>/` y la configuración a `~/.config/<nombre>/`, **nunca dentro de la carpeta del plugin instalado**: se sustituye entera al actualizar.
- Los scripts encuentran la raíz del plugin solos (con `${CLAUDE_SKILL_DIR}` o relativo al propio script); no guardar rutas del plugin en archivos, cambian en cada versión.
- Detalle de plugin y marketplace: [plugins.md](plugins.md).

## Tipo 3: motor de scripts sin app

Una herramienta que se usa desde Claude o la terminal, sin interfaz.

```
motor/        scripts (Python o bash) y sus reglas (motor/REGLAS.md)
pruebas/      una prueba rápida que no gasta nada (correr.sh / correr.py)
mac/ windows/ instaladores
datos/        lo del usuario (fuera de git)
requirements.txt
```

- El CLAUDE.md dice qué comando ejecutar para cada tarea y dónde deja los resultados.
- Si el motor crece y se usa siempre desde Claude, valorar convertirlo en plugin de skills (tipo 2).

## Datos del usuario: siempre fuera de git

En los 3 tipos, lo de cada persona (sus fotos, claves, resultados, `usuario.md` con su nombre y gustos) vive en una carpeta que nunca se sube:
- App local o motor: `datos/` dentro del proyecto, en `.gitignore`, con `datos/.gitkeep` para que la carpeta exista.
- Plugin: `~/<nombre>/` y `~/.config/<nombre>/`.
- Claves: en un `.env` en esa carpeta (`chmod 600` en Mac). **Nunca se escriben en el chat**: Claude da el comando para abrir el archivo y la persona la escribe.

## Un solo código para Mac y Windows

- Rutas con `/`. En Windows, Claude Code ejecuta `bash` con Git Bash, así que Git for Windows es obligatorio.
- Nada de herramientas que solo hay en Mac (`sips`, `mdls`, `xattr`, `stat -f`) sin su alternativa para Windows.
- Python: en Mac `python3` (o un `venv` propio); en Windows `py`. Un `venv` propio evita "funciona en mi equipo".
- Archivos `.sh` con finales de línea LF (con CRLF, Git Bash falla con `\r`).
- Instaladores que se pueden repetir: lo que ya está hecho se salta.
