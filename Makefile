imagename = mongodb-uscities
# -----------------------------------------------------------------
#        Main targets
# -----------------------------------------------------------------

help: ## print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m\t%s\n", $$1, $$2}'

build: ## create the image
	docker build --no-cache -t $(imagename):latest .

push: build ## build and push image
	docker push $(imagename):latest

buildVersion: ## create the image with specified tag, run "make ARGS="1.0" buildVersion"
	docker build --no-cache -t $(imagename):${ARGS} .

pushVersion: ## build and push image with specified tag, run "make ARGS="1.0" pushVersion"
	docker build --no-cache -t $(imagename):${ARGS} .
	docker push $(imagename):${ARGS}
	git tag -a ${ARGS} -m "version ${ARGS}"
	git push --tags

run: ## create a new container from the image
	docker run -p 27017:27017 -d $(imagename)