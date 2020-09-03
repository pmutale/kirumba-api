TAG='latest'
PROJECT='kirumba'

build: Dockerfile ## create the build and runtime images
		@docker build -t $(PROJECT):$(TAG) .

run: Dockerfile
	@docker run --env-file=.env -d -p 7000:7000 $(PROJECT):$(TAG)

build-dev: Dockerfile ## create the dev build and runtime images
	@docker build --build-arg DEV=yes -t  $(PROJECT):dev .


clean: ## remove the latest build
	@docker rmi -f $(PROJECT):$(TAG)

squeaky-clean:  clean  ## aggressively remove unused images
	@docker rmi python:3.8-slim
	@docker system prune -a
	@for image in `docker images -f "dangling=true" -q`; do \
		echo removing $$image && docker rmi $$image ; done

update: ## Grab latest images for project
	@docker pull python:3.8-slim