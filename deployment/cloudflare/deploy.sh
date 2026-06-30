#!/usr/bin/env bash
set -euo pipefail

pnpm install --frozen-lockfile
pnpm build

cat <<'MESSAGE'
Build complete.

Next steps:
1. Build and publish the n8n API image to the container registry used by your
   Cloudflare Container deployment.
2. Publish editor static assets to Cloudflare Pages if you split the frontend.
3. Configure secrets with wrangler secret put.
4. Point Cloudflare DNS or Tunnel at the API origin.
MESSAGE
