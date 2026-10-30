# Secretos y datos personales

## Contenido
- Antes de subir
- Qué buscar
- Si un secreto ya se subió
- Datos personales y privacidad
- Prevenir para siempre

## Antes de subir

1. Copiar a una carpeta nueva solo lo que entra (no publicar la carpeta de trabajo).
2. `.gitignore` desde `assets/gitignore-base` antes del primer `git add`.
3. Ejecutar `scripts/revisar_repo.sh <carpeta> --bloquear "nombre,email,..."`.
4. Añadir archivos uno a uno o por carpeta (`git add README.md skills/`), no `git add .` a ciegas.
5. Mirar `git diff --cached --stat` antes de cada commit.

## Qué buscar

- Claves y tokens: `sk-...` (OpenAI/Anthropic), `ghp_` / `github_pat_` (GitHub), `AKIA...` (AWS), `AIza...` (Google), `xox...` (Slack), `-----BEGIN ... PRIVATE KEY-----`.
- Archivos: `.env`, `*.pem`, `*.key`, `id_rsa`, `credentials.json`, cookies, exportaciones de bases de datos.
- Rutas que revelan el usuario: `/Users/nombre/`, `C:\Users\nombre\`, `/home/nombre/`.
- Metadatos de fotos y vídeos (ubicación, cámara, autor): limpiarlos antes de subir.
- Basura del sistema: `.DS_Store`, `Thumbs.db`.

Las variables de entorno o un gestor de secretos son el sitio de las claves; en el repo solo un `.env.example` con nombres y valores vacíos.

## Si un secreto ya se subió

1. **Primero revocar o cambiar la clave** en el servicio. Una clave revocada ya no sirve, y a veces con eso basta.
2. Borrar del historial con `git-filter-repo` (versión 2.47 o más):
   - Un archivo: `git-filter-repo --sensitive-data-removal --invert-paths --path <ruta>`
   - Un texto: `git-filter-repo --sensitive-data-removal --replace-text <archivo-con-textos>`
3. `git push --force --mirror origin`: reescribe todo; cambian los hashes, se pierden firmas; cerrar PRs abiertas antes y avisar al equipo para que vuelva a clonar (si hacen merge, el secreto vuelve).
4. Los forks, clones ajenos y vistas en caché pueden conservarlo. Por eso el paso 1 es el importante.

## Datos personales y privacidad

Antes de publicar, preguntar al dueño qué puede salir. Lista típica de lo que NO debe salir sin permiso:
- Nombre real, emails, teléfonos, direcciones.
- Rutas del ordenador personal.
- Fotos o vídeos con caras (propias o ajenas), capturas con seguidores o comentarios de otras personas.
- Nombres de clientes, precios internos, conversaciones.
- Material con derechos de terceros en repos públicos (música comercial, fuentes de pago, logos).

En un repo privado de equipo se puede relajar lo de derechos de terceros, pero no lo de secretos: un repo privado se puede volver público por error o compartirse con quien no toca.

## Prevenir para siempre

- Activar secret scanning y push protection (bloquea pushes con claves conocidas).
- Hook pre-commit con `gitleaks` o `git-secrets`, instalado por todo el equipo.
- Revisar siempre con `revisar_repo.sh` antes de cada versión.
