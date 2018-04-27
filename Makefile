all: build

build:
	@docker build --tag=bezeklik/mysql .
