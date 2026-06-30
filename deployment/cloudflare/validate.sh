#!/usr/bin/env bash
set -euo pipefail

command -v node >/dev/null 2>&1 || {
	echo "Node.js is required to validate the n8n Cloudflare deployment build." >&2
	exit 1
}

command -v pnpm >/dev/null 2>&1 || {
	echo "pnpm is required to validate the n8n Cloudflare deployment build." >&2
	exit 1
}

node -e '
const [major, minor] = process.versions.node.split(".").map(Number);
if (major < 22 || (major === 22 && minor < 22)) {
	console.error(`Node.js >=22.22 is required. Current version: ${process.version}`);
	process.exit(1);
}
'

pnpm install --frozen-lockfile
pnpm build

cat <<'MESSAGE'
Build validation complete.

This script does not deploy the n8n API to Cloudflare Workers. The n8n API must
run in Cloudflare Containers or another Node-capable host.

Next steps:
1. Build and publish the n8n API image to the container registry used by your
   Cloudflare Container or external Node runtime.
2. Serve the editor from the n8n server unless you have validated a separate
   Cloudflare Pages deployment.
3. Configure runtime secrets with the selected platform's secret manager.
4. Point Cloudflare DNS or Tunnel at the API origin.
MESSAGE
