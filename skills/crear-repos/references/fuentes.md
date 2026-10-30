# Fuentes

Consultadas el 2026-10-29. Las oficiales (Anthropic, Agent Skills, GitHub) mandan sobre blogs.

## Skills (oficial)
- Anthropic, Skill authoring best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- Agent Skills, Specification: https://agentskills.io/specification
- Claude Code, Skills: https://code.claude.com/docs/en/skills
- Anthropic, skill-creator (SKILL.md): https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md
- Anthropic, repo de ejemplo: https://github.com/anthropics/skills

## Plugins y marketplaces (oficial)
- Crear un plugin: https://code.claude.com/docs/en/plugins/create.md
- Crear un marketplace: https://code.claude.com/docs/en/plugin-marketplaces
- Alojar y mantener un marketplace: https://code.claude.com/docs/en/plugins/host-marketplace.md
- Referencia de marketplace.json: https://code.claude.com/docs/en/plugins/marketplace-reference.md

## GitHub (oficial)
- Buenas prácticas de repos: https://docs.github.com/en/repositories/creating-and-managing-repositories/best-practices-for-repositories
- README: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
- Perfil de comunidad: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/about-community-profiles-for-public-repositories
- Archivos grandes: https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github
- Borrar datos sensibles: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
- Topics: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics
- Imagen social: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/customizing-your-repositorys-social-media-preview
- gh repo create: https://cli.github.com/manual/gh_repo_create
- `gh repo edit --help` y `gh release create --help` (comprobados en local con gh 2.101.0)

## Otras
- Licencias: https://choosealicense.com/
- Versiones: https://semver.org/
- README (guías de la comunidad, secundarias): https://thoughtbot.com/blog/how-to-write-a-great-readme , https://www.kunalganglani.com/blog/write-good-readme-guide.md
- Consejos de skills (secundaria): https://www.philschmid.de/agent-skills-tips

## No verificado
- Que secret scanning se active en repos privados depende del plan de GitHub; no se comprobó con una cuenta real.
- La licencia Apache-2.0 no aparece en la portada de choosealicense.com que se leyó; su descripción sale de conocimiento general.
- De conocimiento general, sin fuente leída en esta investigación: que GitHub dibuja diagramas `mermaid`, el formato "conventional commits", las secciones del CHANGELOG (estilo Keep a Changelog), la ruta Insights → Community Standards y las insignias de shields.io.
- Los patrones de claves de `revisar_repo.sh` cubren formatos conocidos; no detectan contraseñas sueltas ni claves de otros servicios. No sustituyen a gitleaks ni a push protection.
