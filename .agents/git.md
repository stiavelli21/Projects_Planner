# Git / Commit Instructions

Read this file only when the user asks to commit and/or push to GitHub.
Ignore it otherwise.

## Repository
GitHub: https://github.com/stiavelli21/Projects_Planner

## Versioning
Version format: `X.Y.Z` (major.minor.patch).

Default behavior on a commit request:
1. Find the current version (see "Files containing the version" below).
2. Increment Z (patch) by 1. Example: 0.5.1 -> 0.5.2.
3. Update the version in every file listed below.
4. Commit with message: `vX.Y.Z` (the new version), e.g. `v0.5.2`.

If the user explicitly asks to commit as a specific version (e.g. "fai
commit come v0.6.0" or "release 1.0.0"), use that version instead of
auto-incrementing, and update all files below accordingly.

## Files containing the version
- `pubspec.yaml`

## Notes
- Never invent a GitHub URL — if the GitHub URL above is not filled in, ask
  the user for the repository URL instead of guessing.
- If a file above no longer contains a version string, or a new file
  should be added to this list, flag it to the user before proceeding.
