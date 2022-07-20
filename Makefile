VERSION=$(shell python get_app_version.py)
TEST_VERSION=v0.0.10

all: version

version:
	@echo Build version: $(VERSION)

docker_build_offline:
	@echo Building offline $(VERSION) and latest
	docker build --build-arg APP_TARGET=lib/local_main.dart -t kostaleonard/populare-offline:latest -t kostaleonard/populare-offline:$(VERSION) .

docker_run_offline:
	@echo Running offline $(VERSION)
	docker run -p 9000:80 kostaleonard/populare-offline:$(VERSION)

docker_push_offline:
	@echo Pushing offline $(VERSION) and latest
	docker push kostaleonard/populare-offline:latest
	docker push kostaleonard/populare-offline:$(VERSION)

docker_build:
	@echo Building $(VERSION) and latest
	docker build -t kostaleonard/populare:latest -t kostaleonard/populare:$(VERSION) .

docker_run:
	@echo Running $(VERSION)
	docker run -p 9000:80 kostaleonard/populare:$(VERSION)

docker_push:
	@echo Pushing $(VERSION) and latest
	docker push kostaleonard/populare:latest
	docker push kostaleonard/populare:$(VERSION)

docker_build_test:
	@echo Building test
	docker build -t kostaleonard/populare:test$(TEST_VERSION) .

docker_push_test:
	@echo Pushing test
	docker push kostaleonard/populare:test$(TEST_VERSION)
