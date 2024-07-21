# Установите базовый образ
FROM node:16

# Установите рабочую директорию
WORKDIR /app

# Скопируйте package.json и package-lock.json
COPY package*.json ./

# Установите зависимости
RUN npm ci

# Скопируйте весь проект в контейнер
COPY . .

# Соберите клиентский код приложения
RUN npm run build

# Укажите команду для запуска приложения
CMD ["npm", "start"]

# Экспонируйте порт 3000
EXPOSE 3000
