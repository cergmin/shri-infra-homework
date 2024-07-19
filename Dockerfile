FROM node:20.14.0-alpine
WORKDIR /usr/src/app

COPY . .
RUN npm ci
RUN npm run build
EXPOSE 3000

CMD npm run start
