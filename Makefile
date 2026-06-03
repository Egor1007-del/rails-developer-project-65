BUNDLE = bundle exec
RAILS = $(BUNDLE) rails

dev: install setup-env db-prepare
	bin/dev

install:
	bundle install
	yarn install

setup-env:
	cp -n .env.example .env || true

db-setup:
	$(RAILS) db:create db:migrate

db-migrate:
	$(RAILS) db:migrate

db-seed:
	$(RAILS) db:seed

assets:
	$(RAILS) assets:precompile

assets-clean:
	$(RAILS) assets:clean

# ===== Render =====

render-build: install setup-env db-migrate db-seed assets assets-clean

render-start:
	$(BUNDLE) puma -C config/puma.rb



test:
	bin/rails db:test:prepare test test:system
lint: 
	bundle exec rubocop
	bundle exec slim-lint app/views