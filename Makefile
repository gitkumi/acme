export PORT?=8080
export DATABASE_URL?=./acme.db
export MIGRATE_DB?=false

export GOOSE_DBSTRING?=$(DATABASE_URL)
export GOOSE_DRIVER:=sqlite3
export GOOSE_MIGRATION_DIR:=./static/sql/migrations

run:
	go run cmd/web/*.go

test:
	gotestsum

dev:
	air

build:
	pnpm build
	esbuild ./internal/pages/*.ts --bundle --outdir=./static/public/assets
	templ generate
	sqlc generate
	tygo generate
	go build -o bin/main cmd/web/*.go

db:
	goose status

migrate:
	goose up

create:
	goose create $(filter-out $@,$(MAKECMDGOALS)) sql

%:
	@:

.PHONY: run test dev build db migrate create
