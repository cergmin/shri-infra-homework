FROM node:20-slim AS base

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN pnpm run build

EXPOSE 3000
CMD [ "npm", "run", "start" ]
