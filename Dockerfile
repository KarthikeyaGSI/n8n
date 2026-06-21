FROM node:22-slim AS builder

RUN corepack enable && corepack prepare pnpm@10.32.1 --activate

WORKDIR /app

# Copy workspace config and root package files first for better caching
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches/ patches/

# Copy all source files
COPY packages/ packages/
COPY scripts/ scripts/

# Skip lefthook install in prepare script (requires git, not available in slim image)
ENV CI=true

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build n8n
RUN pnpm --filter n8n build

# Production stage
FROM node:22-slim

RUN corepack enable && corepack prepare pnpm@10.32.1 --activate

WORKDIR /app

COPY --from=builder /app /app

ENV NODE_ENV=production

EXPOSE 5678

CMD ["pnpm", "--filter", "n8n", "start"]
