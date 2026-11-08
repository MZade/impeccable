# Network-free fork

This fork of [pbakaus/impeccable](https://github.com/pbakaus/impeccable) ships only the Impeccable design skill
(design guidance, audit, critique, polish and the other commands) as plain Markdown. Nothing in it runs code or sends
anything about your work outside your machine. The `offline` branch is the default branch and the one to install.

## What is removed, and why

| Removed | Why |
|---|---|
| `plugin/hooks/hooks.json` | Ran the engine at every session start, after every file edit and at every stop, in every project |
| `plugin/skills/impeccable/scripts/` (launcher, browser scripts, checksums) | The launcher downloads and runs a native engine from GitHub releases |
| Engine features: telemetry, concept rolls, update check, image generation | Telemetry and concept rolls (`impeccable.style/api/roll`, `/api/chosen`), the update check (`impeccable.style/api/version`) and image generation (`api.openai.com`) all lived in the engine |
| `live`, `generate`, `hooks`, `doctor`, `pin` commands and their references | Need the engine |
| `plugin/agents/impeccable-asset-producer.md` | Produces images through outside services |

`SKILL.md` starts with a **Network-free build** section that overrides the reference files: steps that would run the
engine are done by hand (reading the code, judging screenshots), and nothing is fetched from the internet.

The automatic anti-pattern detector is the one real loss. It could come back later as an engine built from this
repository's Rust source with every HTTP client removed.

## Install (Claude Code, user level, no plugin, no hooks)

```powershell
git clone -b offline https://github.com/MZade/impeccable.git "$env:USERPROFILE\.claude\plugin-sources\impeccable"
Copy-Item -Recurse -Force "$env:USERPROFILE\.claude\plugin-sources\impeccable\plugin\skills\impeccable" "$env:USERPROFILE\.claude\skills\"
```

Then use `/impeccable audit <target>` or `/impeccable critique <target>`.

## Take an upstream release

```bash
git fetch upstream
git merge upstream/main          # keep this branch's deletions; re-delete anything new under scripts/ or hooks/
bash tools/verify-offline.sh     # must print OK before you push or re-install
```

Read new or changed reference files for new outbound calls (URLs, `npx`, `curl`, engine verbs) before merging.
