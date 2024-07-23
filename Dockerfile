FROM node:20-slim AS base

WORKDIR /app

RUN corepack enable pnpm && corepack install -g pnpm@latest-9

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile --prod

COPY . .

RUN pnpm run build

EXPOSE 3000
CMD [ "pnpm", "run", "start" ]
