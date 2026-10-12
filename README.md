# omarchy-tmux-vista

**Watch many agents work in parallel — one terminal per agent, one tmux session to rule them all.** 🤖👁️

Two quality-of-life tools for [Omarchy](https://omarchy.org):

| Key | Action |
|---|---|
| `Super + Alt + V` | Open a **tmux vista**: a new terminal showing the same tmux session, but free to display a different window |
| `Super + L` | **Cycle the workspace layout**: dwindle → master → scrolling → dwindle… (persisted per workspace) |

## The problem

You launch several AI agents in one tmux session — one window per agent. But a tmux session displays only *one* window at a time. To watch what each agent is doing you end up copy-pasting terminals, detaching, or squinting at `Ctrl+b w`.

## The solution: tmux vista

A **vista** is an independent view of the same session, built on tmux *grouped sessions*:

```
┌─────────────────────────┐   ┌─────────────────────────┐
│ Terminal 1 (base)       │   │ Terminal 2 (vista)      │
│ ┌─────────────────────┐ │   │ ┌─────────────────────┐ │
│ │ window 1: agent A ◀─┼─┼───┼─┼─▶ window 2: agent B │ │
│ └─────────────────────┘ │   │ └─────────────────────┘ │
└─────────────────────────┘   └─────────────────────────┘
        both share windows (tabs) from session "Work"
```

- Press `Super + Alt + V` again → another vista, another agent (`Work-1`, `Work-2`, …).
- Each view **adapts to its own terminal size** — resize one without touching the other.
- Close the terminal and the view **destroys itself**; the windows keep running in the base session.
- Open a window in any view and it instantly exists in all of them.

One session per workspace, one vista per agent. Zero copy-paste. 🎯

## Usage

```bash
tmux-vista            # views of the "Work" session (default)
tmux-vista agents     # views of a session named "agents"
```

Typical agent flow:

1. `Super + Enter` → terminal with the `Work` tmux session.
2. `Ctrl+b c` → one window per agent, rename them (`Ctrl+b ,`): `claude`, `codex`, `aider`…
3. `Super + Alt + V` → new terminal, free to follow any agent.
4. Repeat step 3 and tile with `Super + V` (or any layout). *Look, ma, all my agents at once!*

## Bonus: layout cycle (`Super + L`)

Cycles the tiled layout of the active workspace: **dwindle → master → scrolling**. The choice is saved per workspace using Omarchy's built-in workspace-layout state, so it survives reboots.

## Installation

```bash
git clone https://github.com/vctorgab/omarchy-tmux-vista.git
cd omarchy-tmux-vista
./install.sh
```

Options:

- `./install.sh --no-bindings` — install only the scripts, no keybindings.
- Want to keep Omarchy's default `Super + L`? Comment out the two lines inside the `omarchy-tmux-vista` block in `~/.config/hypr/bindings.lua`.

Restart Hyprland with `Super + Shift + R` (or re-login) to load the bindings.

## Uninstall

```bash
./uninstall.sh
```

Removes the scripts and the keybindings block cleanly.

## Requirements

- [Omarchy](https://omarchy.org) 4.x (uses its keybinding config and notification API)
- `tmux`, `kitty`, `jq` (all included in Omarchy)

## How it works

tmux allows several sessions to share the same set of windows — that's a *grouped session*. `tmux-vista` creates `Work-1`, `Work-2`, … attached to your current terminal with `destroy-unattached keep-group`: the view dies with its terminal, while the group protects the base session. It also picks a window that no other view is watching yet, so every vista opens on a "free" agent.

---

# Español

**Mira muchos agentes trabajar en paralelo — una terminal por agente, una sola sesión de tmux para gobernarlos a todos.** 🤖👁️

Dos herramientitas para [Omarchy](https://omarchy.org):

| Tecla | Acción |
|---|---|
| `Super + Alt + V` | Abre una **vista de tmux**: una terminal nueva que muestra la misma sesión, pero libre para ver otra ventana |
| `Super + L` | **Rota el layout del workspace**: dwindle → master → scrolling → dwindle… (se recuerda por workspace) |

## El problema

Lanzas varios agentes de IA en una sesión de tmux — una ventana por agente. Pero una sesión muestra *una* ventana a la vez. Para ver qué hace cada agente terminas copiando terminales, desconectando sesión o mirando `Ctrl+b w` entrecerrado los ojos.

## La solución: tmux vista

Una **vista** es una mirada independiente de la misma sesión, construida con *sesiones agrupadas* de tmux:

- `Super + Alt + V` otra vez → otra vista, otro agente (`Work-1`, `Work-2`, …).
- Cada vista **se adapta al tamaño de su propia terminal**.
- Cierras la terminal y la vista **se destruye sola**; las ventanas siguen vivas en la sesión base.
- Abres una ventana en cualquier vista y al instante existe en todas.

Una sesión por workspace, una vista por agente. Cero copiar y pegar. 🎯

## Uso

```bash
tmux-vista            # vistas de la sesión "Work" (por defecto)
tmux-vista agents     # vistas de una sesión llamada "agents"
```

Flujo típico con agentes:

1. `Super + Enter` → terminal con la sesión de tmux `Work`.
2. `Ctrl+b c` → una ventana por agente, renómbralas (`Ctrl+b ,`): `claude`, `codex`, `aider`…
3. `Super + Alt + V` → terminal nueva, libre para seguir a cualquier agente.
4. Repite el paso 3 y acomoda con `Super + V` (o el layout que quieras). *¡Mira, mamá, todos mis agentes a la vez!*

## Bonus: ciclo de layouts (`Super + L`)

Rota el layout del workspace activo: **dwindle → master → scrolling**. La elección se guarda por workspace con el estado nativo de Omarchy, así que sobrevive reinicios.

## Instalación

```bash
git clone https://github.com/vctorgab/omarchy-tmux-vista.git
cd omarchy-tmux-vista
./install.sh
```

- `./install.sh --no-bindings` → solo los scripts, sin keybindings.
- ¿Quieres conservar el `Super + L` original de Omarchy? Comenta las dos líneas del bloque `omarchy-tmux-vista` en `~/.config/hypr/bindings.lua`.

Reinicia Hyprland con `Super + Shift + R` (o vuelve a entrar) para cargar los atajos.

## Desinstalación

```bash
./uninstall.sh
```

Elimina los scripts y el bloque de keybindings limpiamente.

## Requisitos

- [Omarchy](https://omarchy.org) 4.x (usa su configuración de atajos y su API de notificaciones)
- `tmux`, `kitty`, `jq` (vienen en Omarchy)

## Licencia

MIT — úsalo, modifícalo, compártelo. 💋
