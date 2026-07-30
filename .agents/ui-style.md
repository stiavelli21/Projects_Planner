# UI Style

## Principles
- Minimal: no unnecessary elements, no decoration without function.
- Every screen must stay intuitive: minimal does not mean unclear. If
  reducing an element hurts usability, keep it and flag the tradeoff.
- Consistency over novelty: reuse existing patterns/components before
  creating new ones.

## Rules
- Spacing: [____ scale, e.g. 4/8/16/24/32px]
- Typography: [____ font, weights, size scale]
- Components: [____ library used, or "custom, see src/components"]

## Colors
- Default: use the tokens defined in `colors.md` for most UI elements
  (backgrounds, text, primary actions, states).
- Exceptions allowed: a new color can be introduced for a specific
  element (e.g. a single button, a badge, an accent) when it serves a
  clear purpose, as long as it visually harmonizes with the existing
  palette (similar saturation/lightness family, no clashing hues).
- Any new color introduced this way must be added to the "Extended
  colors" section in `colors.md`, with the element it's used for.
- Never invent a color that duplicates or nearly duplicates an existing
  token — reuse the token instead.

## Before adding a new UI pattern
Check if an existing component/pattern already covers the need. If not,
propose it before implementing and explain why the existing ones don't
fit.
