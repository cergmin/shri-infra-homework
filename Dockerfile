# Используем базовый образ с Node.js
FROM node

# Создаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json в рабочую директорию
COPY package*.json ./

# Устанавливаем зависимости
RUN npm ci

# Копируем файлы проекта в рабочую директорию
COPY . .

# Указываем порт, на котором будет работать приложение
EXPOSE 3000

# Запускаем приложение
CMD ["npm", "start"]