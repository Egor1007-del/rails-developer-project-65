### Hexlet tests and linter status:
[![Actions Status](https://github.com/Egor1007-del/rails-developer-project-65/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Egor1007-del/rails-developer-project-65/actions)

### CI
[![CI](https://github.com/Egor1007-del/rails-developer-project-65/actions/workflows/ci.yml/badge.svg)](https://github.com/Egor1007-del/rails-developer-project-65/actions/workflows/ci.yml)


# Rails Project 3

Доска объявлений на Ruby on Rails.

## Live Demo

[![Render](https://img.shields.io/badge/Render-Deployed-success)](https://rails-developer-project-65-1.onrender.com)

https://rails-developer-project-65-1.onrender.com

## Features

### Authentication

- Авторизация через GitHub OAuth
- Профиль пользователя
- Разделение прав доступа для пользователей и администраторов

### Bulletins

- Создание объявлений
- Редактирование собственных объявлений
- Просмотр объявлений
- Архивирование объявлений
- Загрузка изображений через Active Storage

### Moderation

- Административная панель
- Управление категориями
- Публикация объявлений
- Отклонение объявлений
- Архивирование объявлений

### Search and Filters

- Поиск по названию объявления
- Фильтрация по категориям
- Фильтрация по состояниям
- Пагинация с Kaminari

### Internationalization

- Русский язык
- Английский язык

## Bulletin States

Объявления проходят следующие состояния:

- draft
- under_moderation
- published
- rejected
- archived

## Technologies

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

## Installation

### Clone repository

```bash
git clone https://github.com/Egor1007-del/rails-developer-project-65.git

cd rails-developer-project-65
```

### Create environment file

```bash
cp .env.example .env
```

### Environment variables

```env
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
SENTRY_DSN=
```

### Install dependencies and setup project

```bash
make dev
```

Команда выполняет:

- установку gem-зависимостей;
- установку JavaScript-зависимостей;
- настройку окружения;
- создание базы данных;
- выполнение миграций;
- загрузку тестовых данных.

### Run application

```bash
bin/dev
```

После запуска приложение будет доступно по адресу:

```text
http://localhost:3000
```

## Database

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

## Tests

Запуск всех тестов:

```bash
make test
```

или

```bash
bin/rails test
```

## Lint

Запуск Rubocop и Slim-Lint:

```bash
make lint
```

Отдельно:

```bash
bundle exec rubocop
bundle exec slim-lint app/views
```

## Project Structure

### Main Pages

- Главная страница
- Страница объявления
- Создание объявления
- Редактирование объявления
- Профиль пользователя
- Административная панель
- Управление категориями
- Модерация объявлений

### User Roles

#### User

- Создание объявлений
- Редактирование собственных объявлений
- Отправка объявления на модерацию
- Архивирование собственных объявлений

#### Admin

- Управление категориями
- Публикация объявлений
- Отклонение объявлений
- Архивирование объявлений
- Доступ к административной панели

## Deployment

Проект разворачивается на Render.

### Build Command

```bash
make render-build
```

### Start Command

```bash
make render-start
```

## Author

Egor1007