---
name: <nombre-en-minusculas-igual-que-la-carpeta>
description: <Qué hace, en tercera persona y con verbos concretos.> Úsala siempre que el usuario diga "<frase 1>", "<frase 2>", "<frase 3>" o <contexto en el que sirve>.
---

# <Título>

<Una o dos frases: objetivo y resultado que recibe el usuario.>

## Progreso

```
- [ ] 1. <paso>
- [ ] 2. <paso>
- [ ] 3. Comprobar
- [ ] 4. Responder
```

## Paso 1: <nombre>

<Instrucción concreta. Si hay una sola forma segura, el comando exacto:>

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/<script>.sh" "<entrada>"
```

<Por qué se hace así, en una frase.>

## Paso 2: <nombre>

<...>

## Paso 3: comprobar

<Validación → si falla, corregir y repetir. Solo seguir cuando pase.>

## Paso 4: responder

- Lo que falló o no se probó, primero.
- <Qué entregar y en qué formato.>

## Más detalle

- <Tema>: [references/<tema>.md](references/<tema>.md)
