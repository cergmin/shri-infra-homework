# syntax=docker/dockerfile:1

# Комментарии приведены по всему этому файлу, чтобы помочь вам начать.
# Если вам нужно больше помощи, посетите справочное руководство по Dockerfile на
# https://docs.docker.com/go/dockerfile-reference/

# Хотите помочь нам улучшить этот шаблон? Оставьте свой отзыв здесь: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG NODE_VERSION=18.18.1

################################################################################
# Используйте образ node в качестве базового образа для всех этапов.
FROM node:${NODE_VERSION}-alpine as base

# Устанавливаем рабочую директорию для всех этапов сборки.
WORKDIR /usr/src/app


################################################################################
# Создаем этап для установки production-зависимостей.
FROM base as deps

# Скачиваем зависимости на отдельном шаге, чтобы использовать кэширование Docker.
# Используем кэш монтирования в /root/.npm, чтобы ускорить последующие сборки.
# Используем привязки к package.json и package-lock.json, чтобы избежать их копирования
# на этот уровень.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

################################################################################
# Создаем этап для сборки приложения.
FROM deps as build

# Скачиваем дополнительные зависимости для разработки перед сборкой, так как некоторые проекты требуют
# установки "devDependencies" для сборки. Если это не нужно, удалите этот шаг.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci

# Копируем остальные исходные файлы в образ.
COPY . .
# Запускаем скрипт сборки.
RUN npm run build

################################################################################
# Создаем новый этап для запуска приложения с минимальными зависимостями во время выполнения,
# где необходимые файлы копируются из этапа сборки.
FROM base as final

# По умолчанию используем production-окружение node.
ENV NODE_ENV production

# Запускаем приложение от имени непривилегированного пользователя.
USER node

# Копируем package.json, чтобы можно было использовать команды менеджера пакетов.
COPY package.json .

# Копируем production-зависимости с этапа deps и
# собранное приложение с этапа build в образ.
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/. ./.

# Открываем порт, на котором приложение будет прослушивать.
EXPOSE 3000

# Запускаем приложение.
CMD ["npm", "start"]
