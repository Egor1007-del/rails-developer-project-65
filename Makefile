install:
	bundle install
test:
	bin/rails db:test:prepare test test:system
lint: 
	bundle exec rubocop
	bundle exec slim-lint app/views