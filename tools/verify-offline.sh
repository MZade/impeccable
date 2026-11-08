#!/bin/sh
# Fails when the shipped plugin could run code or reach the internet.
# Checks only plugin/ (what gets installed); the rest of the repo is upstream source.
cd "$(dirname "$0")/.." || exit 2
fail=0
note() { echo "FAIL: $*"; fail=1; }

[ -e plugin/hooks ] && note "plugin/hooks exists"
[ -e plugin/skills/impeccable/scripts ] && note "skill scripts/ (engine launcher) exists"
for f in $(find plugin -type f ! -name '*.md' ! -name 'plugin.json' ! -path 'plugin/.grok-plugin/*'); do
  note "non-Markdown file shipped: $f"
done
grep -q '^## Network-free build' plugin/skills/impeccable/SKILL.md || note "SKILL.md lost its Network-free build section"
grep -rqE '"hooks"|mcpServers' plugin/.claude-plugin/plugin.json && note "plugin.json declares hooks or MCP servers"
# Every URL in plugin/ must be a reviewed link (metadata or documentation, never an endpoint the skill calls).
# Add a URL to tools/reviewed-urls.txt only after reading the line it appears on.
grep -rnoE "https?://[^ )\"'\`>]+" plugin | grep -vE '://(127\.0\.0\.1|localhost)|example\.(com|org)|\.test/|www\.w3\.org'   | while IFS= read -r hit; do url=${hit#*:*:}; grep -qxF "$url" tools/reviewed-urls.txt || echo "  url: $hit"; done > /tmp/verify-offline-urls.$$
if [ -s /tmp/verify-offline-urls.$$ ]; then note "unreviewed URLs in plugin/:"; cat /tmp/verify-offline-urls.$$; fi
rm -f /tmp/verify-offline-urls.$$

[ "$fail" = 0 ] && echo "OK: plugin/ ships Markdown only, no hooks, no engine, no unreviewed URLs"
exit $fail
