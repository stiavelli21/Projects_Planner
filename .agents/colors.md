# Color Palette

## Core tokens
These are the default colors for the app. Use these first.

| Name       | Hex     | Usage                    |
|------------|---------|---------------------------|
| primary    | #FF6B6B | main actions, links        |
| background | #F8F9FA | page/app background        |
| surface    | #FFFFFF | cards, panels               |
| text       | #2D3436 | primary text                |
| muted      | #B2BEC3 | secondary text, borders     |
| error      | #B3261E | errors, destructive actions |
| success    | #6BCB77 | confirmations                |

## Extended colors
One-off colors used for specific elements, allowed when they harmonize
with the core tokens above (see `ui-style.md` for the rule). Log them
here so the palette stays traceable over time.

| Name | Hex | Used for | Why default tokens didn't fit |
|------|-----|----------|-------------------------------|
|      |     |          |                                 |

## Rules
- Prefer core tokens for anything reused across the app.
- Extended colors are for single, specific elements — not for new
  recurring patterns. If an extended color starts being reused in
  multiple places, promote it to a core token instead.
- Never use raw hex directly in components — always reference a token
  (core or extended) defined here.
