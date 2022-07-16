VERSION=$(shell python get_app_version.py)

all: version

version:
	@echo Build version: $(VERSION)

docker_build_offline:
	@echo Building offline $(VERSION) and latest
	# TODO add build arg to configure online/offline
	docker build -t kostaleonard/populare-offline:latest build -t kostaleonard/populare-offline:$(VERSION) .

docker_run_offline:
	@echo Running offline $(VERSION)
	docker run -p 9000:80 kostaleonard/populare-offline:$(VERSION)

docker_build:
	@echo Building $(VERSION) and latest
	# TODO add build arg to configure online/offline
	docker build -t kostaleonard/populare:latest build -t kostaleonard/populare:$(VERSION) .

docker_run:
	@echo Running $(VERSION)
	docker run -p 9000:80 kostaleonard/populare:$(VERSION)
