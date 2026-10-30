# Fuentes

Consultadas el 2026-10-29 y comprobadas de nuevo el 2026-10-30. Las oficiales mandan sobre blogs.

## Oficiales
- Anthropic, Skill authoring best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- Agent Skills, Specification (campos y límites del frontmatter): https://agentskills.io/specification
- Claude Code, Skills (dónde viven, prioridad, `${CLAUDE_SKILL_DIR}`, límite de 1.536 caracteres, menos de 500 líneas, nombre reservado `synced`, `/reload-skills`): https://code.claude.com/docs/en/skills
- Claude Code, instalación en Windows (Git for Windows para el Bash tool; sin él, PowerShell): https://code.claude.com/docs/en/setup
- Anthropic, skill-creator (SKILL.md): https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md
- Anthropic, repo de ejemplo: https://github.com/anthropics/skills

## Secundarias
- Consejos de skills: https://www.philschmid.de/agent-skills-tips

## No verificado
- `claude plugin eval` existe en Claude Code 2.1.296 (comprobado con `claude plugin --help`); no se probó en versiones anteriores ni se ejecutó con casos reales.
- La cifra de "~100 tokens" por skill en metadatos y "< 5.000 tokens" para el cuerpo vienen de la guía de Anthropic; no se midieron.
- El comportamiento en Windows del script `revisar_skill.sh` no se probó en un Windows real.
