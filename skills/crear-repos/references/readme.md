# README profesional

## Contenido
- Para qué sirve
- Orden de secciones
- Portada y visuales
- Instalación que funcione a la primera
- Reglas de formato de GitHub
- Errores típicos

## Para qué sirve

Es la puerta de entrada: lo primero que ve un usuario, un compañero o un posible cliente. Tiene que responder en este orden: **qué es, por qué sirve, cómo se instala, cómo se usa**. No tiene que ser largo, tiene que ser bueno. Lo largo va a `docs/`.

Idea útil ("README primero", Tom Preston-Werner, 2010): escribir el README antes de terminar el proyecto obliga a aclarar qué hace.

## Orden de secciones

Orden Maestría (el de Carrusel Creator Pro y Crear Vídeos Pro):

1. **Portada** centrada: nombre, una frase en negrita con el resultado, insignias (Mac, Windows y las herramientas clave) y un antes/después en dos columnas.
2. **Resultados reales** (opcional): capturas o números con su fuente y fecha.
3. **Vídeo de ejemplo** (opcional): miniatura que enlaza a YouTube.
4. **Qué hace**: 3–5 viñetas con resultados, no características técnicas.
5. **Cómo funciona**: tabla Paso · Quién · Qué pasa.
6. **Úsalo desde Claude (o desde la app)**: la frase exacta que lo pone en marcha.
7. **Mac y Windows**: tabla con guía, instalar, actualizar, arrancar y herramientas de cada sistema, y la frase *"instálame esto"*.
8. **Lo que necesitas**: cuentas y claves, para qué y cuánto dan de sí; que cada persona usa las suyas y que sus datos no se suben.
9. **Estructura**: árbol de carpetas con una línea cada una y enlace a CLAUDE.md.
10. **Lo que no hace**: límites reales. Evita falsas expectativas y preguntas.
11. **Actualizar**: el comando.
12. **Versiones probadas**: versiones exactas de las herramientas con las que se probó y lo que no se probó.
13. **Licencia** (repos públicos).

Plantilla: `assets/plantilla-README.md`.

## Portada y visuales

- Imágenes en `docs/` del propio repo y enlazadas con ruta relativa (`docs/portada.png`): siguen funcionando en clones y en cualquier rama.
- GitHub no permite iframes: un vídeo de YouTube va como miniatura que enlaza al vídeo:
  `[![Ver vídeo](docs/miniatura.jpg)](https://www.youtube.com/watch?v=ID)`
- GIF corto (< 10 s) o imagen comparativa para enseñar el resultado de un vistazo.
- Diagramas: GitHub dibuja bloques ```` ```mermaid ```` directamente.
- Imágenes ligeras (comprimidas); nada de vídeos pesados en el repo (ver límites en archivos-repo.md).
- Sin caras ni datos de otras personas salvo permiso; recortar capturas que muestren seguidores o comentarios ajenos.

## Instalación que funcione a la primera

- Un bloque por comando, sin `$` delante, listo para copiar.
- Decir requisitos antes (git, gh, Claude Code, ffmpeg...) con cómo instalarlos.
- Si hay script instalador: uno para Mac/Linux (`instalar.sh`) y otro para Windows (`instalar.cmd` o `.ps1`).
- Validarlo siguiendo el README al pie de la letra en una carpeta limpia (paso 7 de la skill). Lo que falle se arregla en el README, no "de palabra".

## Reglas de formato de GitHub

- GitHub muestra el primer README que encuentra en `.github/`, luego raíz, luego `docs/`.
- Genera índice automático (botón Outline) a partir de los títulos: usar `##` con nombres claros.
- Cada título tiene ancla: `[Instalación](#instalación)`.
- Rutas relativas al archivo; las que empiezan por `/` son desde la raíz. El texto de un enlace en una sola línea o no se dibuja.
- Más de 500 KiB de README se corta.

## Errores típicos

- Empezar por la historia del proyecto en vez de qué hace.
- Instalación "obvia" que falla en un ordenador limpio.
- Enlaces absolutos a archivos del repo que se rompen al cambiar de rama.
- Capturas con datos personales, rutas `/Users/...` o emails.
- No decir la licencia en un repo público.
