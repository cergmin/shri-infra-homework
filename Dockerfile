
    ARG NODE_VERSION=20.14.0

    FROM node:${NODE_VERSION}-alpine as base

    WORKDIR /app

    COPY package.json package-lock.json ./

    RUN npm install

    COPY . ./

    RUN npm run build

    EXPOSE 3000

    CMD npm start
