# syntax=docker/dockerfile:1

FROM node:18-alpine AS base
WORKDIR /app

# Install dependencies in separate layer for better caching
FROM base AS deps
COPY package.json package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production

# Development dependencies
FROM base AS deps-dev
COPY package.json package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# Build stage (if needed for compilation)
FROM deps-dev AS build
COPY . .
# Add any build commands here if needed

# Production stage
FROM base AS production
COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
CMD ["npm", "start"]
