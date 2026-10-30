<!-- Plantilla Maestría. Cambiar todo lo que está entre < > y borrar las secciones marcadas (opcional) que no apliquen. -->

<div align="center">

# <Nombre del proyecto>

**<Qué hace en una frase, con el resultado que recibe el usuario.>**

![Mac](https://img.shields.io/badge/Mac-listo-000000?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows%2010%20%2F%2011-listo-0078D4)
![Claude](https://img.shields.io/badge/Claude-Code-D97757?logo=anthropic&logoColor=white)
<!-- Una insignia por herramienta clave (Next.js, Python, Codex...). Pocas. -->

<Una o dos frases: dónde corre (tu equipo, Claude Code) y qué hace cada pieza.>

<!-- Portada: antes/después en dos columnas. Imágenes en docs/img/, con alt que describa lo que se ve. -->
<table>
  <tr>
    <th>📥 <Lo que entra></th>
    <th>✨ <Lo que sale></th>
  </tr>
  <tr>
    <td><img src="docs/img/antes.jpg" alt="<qué se ve>" width="100%"></td>
    <td><img src="docs/img/despues.jpg" alt="<qué se ve>" width="100%"></td>
  </tr>
  <tr>
    <td align="center"><sub><fuente o explicación></sub></td>
    <td align="center"><sub><qué cambió></sub></td>
  </tr>
</table>

</div>

---

## 📈 Resultados reales (opcional)

<Capturas o números reales, con su fuente y fecha. Recortar datos de otras personas.>

## ▶️ Vídeo de ejemplo (opcional)

<!-- GitHub no muestra vídeos de YouTube incrustados: miniatura que enlaza al vídeo. -->
[![Ver vídeo de ejemplo](docs/img/video-miniatura.jpg)](https://www.youtube.com/watch?v=<ID>)

## Qué hace

- <Resultado 1 que obtiene el usuario>
- <Resultado 2>
- <Resultado 3>

## Cómo funciona

| Paso | Quién | Qué pasa |
|---|---|---|
| <Entrada> | El usuario | <qué pone> |
| <Paso> | Claude / el motor / la app | <qué hace> |
| <Resultado> | <quién> | <qué sale y dónde se guarda> |

## Úsalo desde Claude (o desde la app)

Abre Claude Code en la carpeta del proyecto y di:

> <frase exacta que lo pone en marcha>

<!-- Tipo plugin: "/<plugin>:<skill>". Tipo app: cómo arrancarla y que lo hecho desde Claude aparece en la app. -->

## Mac y Windows

| | 🍎 Mac | 🪟 Windows 10 / 11 |
|---|---|---|
| **Guía de instalación** | [`INSTALAR.md`](INSTALAR.md#mac) | [`INSTALAR.md`](INSTALAR.md#windows) |
| **Instalar** | `bash mac/instalar.sh` | `windows\instalar.cmd` |
| **Actualizar** | `bash mac/actualizar.sh` | `windows\actualizar.cmd` |
| **Arrancar** (solo app) | `bash mac/arrancar.sh` | `windows\arrancar.cmd` |
| **Herramientas** | Homebrew: <lista> | winget: <lista> + Git for Windows |

**Lo más fácil:** abre Claude Code dentro de la carpeta y dile *"instálame esto"*. Sigue la guía de tu sistema y te dice qué tienes que hacer tú.

## Lo que necesitas

| | |
|---|---|
| 🤖 **Claude Code** con tu cuenta | <para qué> |
| 🔑 **<Servicio o clave>** | <para qué, cuánto cuesta o cuánto da de sí (medido o publicado, decir cuál)> |

Cada persona usa **sus propias cuentas**. Todo lo tuyo (<archivos, claves, resultados> y `usuario.md`, donde Claude apunta tu nombre y tus gustos) vive en `<carpeta de datos>`, que nunca se sube a GitHub.

## Estructura

```
<carpeta>/   <qué hay>
<carpeta>/   <qué hay>
```

[`CLAUDE.md`](CLAUDE.md) es el manual del proyecto para Claude.

## Lo que no hace

- <Límite real 1 (por ejemplo: no publica en Instagram)>
- <Límite real 2 (por ejemplo: no funciona sin internet)>
- <Lo que el usuario tiene que revisar él>

## Actualizar

```bash
bash mac/actualizar.sh
```

En Windows: `windows\actualizar.cmd`.

## Versiones probadas

<Herramienta> **<versión>** y Claude Code **<versión>**, en <Mac / Windows>. <Lo que no se probó.>

## Licencia

<MIT — ver [LICENSE](LICENSE). / Uso interno del equipo.>
