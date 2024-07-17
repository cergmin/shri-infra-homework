ARG NODE_VERSION=20.10.0

FROM node:${NODE_VERSION}-alpine AS base

WORKDIR /usr/src/app

COPY . .

RUN npm ci --verbose

RUN npm run build --verbose

ENV NODE_ENV=production

EXPOSE 3000

CMD ["npm", "start"]