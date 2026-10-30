# Archivos del repo, versiones y límites

## Contenido
- Qué archivos poner según el tipo de repo
- Licencias
- CONTRIBUTING, SECURITY, CHANGELOG, plantillas
- Versiones (SemVer) y releases
- Commits
- Descripción, topics e imagen para compartir
- Límites de tamaño
- Ramas y protección
- Seguridad de GitHub que activar

## Qué archivos poner según el tipo de repo

| Archivo | Privado de equipo | Público |
|---|---|---|
| `README.md` | Sí | Sí |
| `.gitignore` | Sí | Sí |
| `LICENSE` | No hace falta | **Sí** |
| `CHANGELOG.md` | Recomendado | Recomendado |
| `CONTRIBUTING.md` | Opcional | Si se aceptan aportes |
| `SECURITY.md` | Opcional | Recomendado |
| `CODE_OF_CONDUCT.md` | No | Si hay comunidad |
| `.github/ISSUE_TEMPLATE/` | No | Si hay comunidad |

GitHub revisa en repos públicos (Insights → Community Standards) si hay README, CODE_OF_CONDUCT, LICENSE y CONTRIBUTING, entre otros. Estos archivos pueden ir en la raíz, en `docs/` o en `.github/`. Un repo público llamado `.github` en la cuenta u organización sirve de valores por defecto para los repos que no tengan los suyos.

## Licencias

Sin licencia, el código no se puede reutilizar legalmente aunque sea público. Elegir en choosealicense.com:
- **MIT**: corta y permisiva; casi todo permitido, también versiones cerradas. La opción por defecto para compartir skills.
- **Apache-2.0**: permisiva y añade permiso explícito de patentes. Es la que usa Anthropic en muchas skills de `anthropics/skills`.
- **GPL-3.0**: permite casi todo salvo distribuir versiones cerradas.
- Privado o con material de pago/terceros: no poner licencia abierta. Si se quiere dejar claro: `LICENSE` con "Uso interno. Todos los derechos reservados" (no es consejo legal; ante dudas, consultar).
- Con `gh repo create --license mit` se crea al vuelo.
- Material de terceros (fuentes, música, logos): no se puede relicenciar. En repos públicos, no incluir lo que no tengas derecho a redistribuir y listar créditos en `THIRD_PARTY_NOTICES.md` si aplica.

## CONTRIBUTING, SECURITY, CHANGELOG, plantillas

- `CONTRIBUTING.md`: cómo proponer cambios (rama, estilo de commits, cómo probar una skill antes del PR).
- `SECURITY.md`: cómo avisar de un fallo de seguridad en privado (activar "Private vulnerability reporting").
- `CHANGELOG.md`: lista de cambios por versión, lo nuevo arriba, con secciones Añadido / Cambiado / Arreglado / Quitado.
- Plantillas de issues en `.github/ISSUE_TEMPLATE/` (`.md` con `name:` y `about:`, o formularios `.yml` con `name:` y `description:`).

## Versiones (SemVer) y releases

`MAJOR.MINOR.PATCH`:
- MAJOR: cambios que rompen (renombrar una skill, cambiar cómo se instala).
- MINOR: añadir algo sin romper (una skill nueva).
- PATCH: arreglos.
- `0.y.z`: fase inicial, todo puede cambiar.

Publicar:
```bash
git tag v1.0.0 && git push origin v1.0.0
gh release create v1.0.0 --generate-notes
```
En plugins, la `version` de `plugin.json` debe ir a la par del tag (o no ponerla; ver plugins.md).

## Commits

Formato "conventional commits": `tipo: descripción` con tipos `feat`, `fix`, `docs`, `refactor`, `chore`, `test`. Mensajes que digan qué cambia para el usuario. Facilita generar el CHANGELOG.

## Descripción, topics e imagen para compartir

- Descripción: una frase con qué hace (`gh repo edit --description "..."`).
- Topics: máx. 20; minúsculas, números y guiones; máx. 50 caracteres cada uno. Ayudan a que lo encuentren (`claude-code`, `claude-skills`, `agent-skills`, el tema).
- Imagen social (la que sale al compartir el enlace): 1280×640 px ideal (mínimo 640×320), PNG/JPG/GIF, máx. 1 MB. Settings → General → Social preview.

## Límites de tamaño

- Archivo > **50 MiB**: aviso.
- Archivo > **100 MiB**: GitHub lo bloquea.
- Subida por navegador: máx. **25 MiB**.
- Repo ideal < **1 GB**; muy recomendable < **5 GB**.
- Archivos grandes → Git LFS (pero no para archivos que use un plugin de Claude: no se descargan al instalar). Alternativa: guardarlos en Releases o en un almacenamiento aparte y enlazarlos.

## Ramas y protección

- `main` como rama principal; cambios en ramas y Pull Request.
- Equipo habitual: ramas en el mismo repo, no forks. Forks para gente de fuera.
- Proteger `main` (Settings → Rules) con PR obligatoria y revisiones cuando haya varias personas.

## Seguridad de GitHub que activar

Mínimo recomendado por GitHub (gratis en públicos): alertas de Dependabot, secret scanning, push protection y code scanning.
```bash
gh repo edit cuenta/repo --enable-secret-scanning --enable-secret-scanning-push-protection
```
En privados puede depender del plan; si da error, se avisa y se sigue.
