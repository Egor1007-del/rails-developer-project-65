[![Actions Status](https://github.com/Egor1007-del/rails-developer-project-65/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Egor1007-del/rails-developer-project-65/actions)

[![CI](https://github.com/Egor1007-del/rails-developer-project-65/actions/workflows/ci.yml/badge.svg)](https://github.com/Egor1007-del/rails-developer-project-65/actions/workflows/ci.yml)

[![Render](https://img.shields.io/badge/Render-Deployed-success)](https://rails-developer-project-65-1.onrender.com)

# Доска объявлений

Доска объявлений на Ruby on Rails.

## Демонстрация проекта

https://rails-developer-project-65-1.onrender.com

## Возможности

### Авторизация

- Авторизация через GitHub OAuth
- Личный кабинет пользователя
- Разделение прав доступа пользователей и администраторов

### Объявления

- Создание объявлений
- Редактирование собственных объявлений
- Просмотр объявлений
- Архивирование объявлений
- Загрузка изображений через Active Storage

### Модерация

- Административная панель
- Управление категориями
- Публикация объявлений
- Отклонение объявлений
- Архивирование объявлений

### Поиск и фильтрация

- Поиск по названию объявления
- Фильтрация по категориям
- Фильтрация по состояниям
- Пагинация с использованием Kaminari

### Интернационализация

- Русский язык
- Английский язык

## Состояния объявлений

Объявления могут находиться в следующих состояниях:

- draft
- under_moderation
- published
- rejected
- archived

## Используемые технологии

- Ruby 3.3.4
- Rails 7.2
- PostgreSQL
- Bootstrap 5
- Slim
- OmniAuth GitHub
- Pundit
- AASM
- Ransack
- Kaminari
- Active Storage
- Sentry

## Установка и запуск

### Клонирование репозитория

```bash
git clone https://github.com/Egor1007-del/rails-developer-project-65.git

cd rails-developer-project-65
```

### Создание файла окружения

```bash
cp .env.example .env
```

### Переменные окружения

```env
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
SENTRY_DSN=
```

### Установка зависимостей и настройка проекта

```bash
make dev
```

Команда выполняет:

- установку Ruby-зависимостей;
- установку JavaScript-зависимостей;
- создание файла окружения;
- создание базы данных;
- выполнение миграций;
- загрузку тестовых данных.

### Запуск приложения

```bash
bin/dev
```

После запуска приложение будет доступно по адресу:

```text
http://localhost:3000
```

## Работа с базой данных

Создание базы данных:

```bash
bin/rails db:create
```

Выполнение миграций:

```bash
bin/rails db:migrate
```

Заполнение базы тестовыми данными:

```bash
bin/rails db:seed
```

## Тестирование

Запуск всех тестов:

```bash
make test
```

или

```bash
bin/rails test
```

## Проверка качества кода

Запуск Rubocop и Slim-Lint:

```bash
make lint
```

Отдельный запуск:

```bash
bundle exec rubocop
bundle exec slim-lint app/views
```

## Структура проекта

### Основные страницы

- Главная страница
- Просмотр объявления
- Создание объявления
- Редактирование объявления
- Личный кабинет пользователя
- Административная панель
- Управление категориями
- Модерация объявлений

### Роли пользователей

#### Пользователь

- Создание объявлений
- Редактирование собственных объявлений
- Отправка объявлений на модерацию
- Архивирование собственных объявлений

#### Администратор

- Управление категориями
- Публикация объявлений
- Отклонение объявлений
- Архивирование объявлений
- Доступ к административной панели

## Развертывание

Проект развернут на платформе Render.

### Команда сборки

```bash
make render-build
```

### Команда запуска

```bash
make render-start
```

## Автор

Egor1007