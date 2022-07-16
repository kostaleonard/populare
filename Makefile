all: help

help:
	@echo This Makefile is used for building and configuring the Docker container.

docker_build:
	@echo Building container.
	# TODO add tag for version
	# TODO add build for offline version (separate make target)
	docker build -t kostaleonard/populare:latest .

docker_run:
	@echo Running latest.
	docker run -p 9000:80 kostaleonard/populare:latest
