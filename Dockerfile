FROM node:20

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем исходный код приложения
COPY . .

# Выполняем сборку приложения (если это необходимо)
RUN npm run build

# Открываем порт для приложения
EXPOSE 3000

# Запускаем приложение
CMD [ "npm", "start" ]
