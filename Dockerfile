FROM ubuntu
FROM node

WORKDIR /app

COPY package*.json ./

RUN npm i
RUN npm install webpack --save-dev

COPY . .

ENV PORT=3000

EXPOSE 3000

RUN npm run build

CMD [ "npm", "start" ]