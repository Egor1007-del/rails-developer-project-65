BUNDLE = bundle exec
RAILS = $(BUNDLE) rails

.PHONY: setup dev start install setup-env db-setup db-migrate db-seed assets assets-clean render-build render-start test lint

dev: install setup start
	
install:
	bundle install
	yarn install

setup-env:
	cp -n .env.example .env || true

db-setup:
	$(RAILS) db:create db:migrate db:seed

db-migrate:
	$(RAILS) db:migrate

db-seed:
	$(RAILS) db:seed

assets:
	$(RAILS) assets:precompile

assets-clean:
	$(RAILS) assets:clean

setup: setup-env install db-setup

start:
	bin/dev

# ===== Render =====

render-build: install setup-env db-migrate db-seed assets assets-clean

render-start:
	$(BUNDLE) puma -C config/puma.rb



test:
	bin/rails db:test:prepare db-seed test test:system
lint: 
	bundle exec rubocop
	bundle exec slim-lint app/views
