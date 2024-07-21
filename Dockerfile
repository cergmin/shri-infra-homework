FROM node:20-alpine3.18 as builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine3.18 as runner

WORKDIR /app

COPY --from=builder /app .

RUN npm i -g ts-node

CMD ["ts-node", "src/server/index.ts"]

