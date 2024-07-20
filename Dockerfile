FROM --platform=linux/amd64 node:18-alpine
WORKDIR /app

COPY . .

RUN npm ci
RUN npm run build

# ENV NODE_ENV production

EXPOSE 3000

CMD [ "npm", "start" ] 