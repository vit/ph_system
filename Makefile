

##
##
##


-include .env_default
-include .env
export


help:	## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)






# config:
# 	./config.sh

# build:	build-news build-hugo ## Generate the sites from src to dst

run: up

stop: down






debug:	## Start docker compose with debug output
	docker compose up

up:	## Start docker compose detouched
	docker compose up -d

down:	## Stop docker compose
	docker compose down

ps:	## List docker compose containers
	docker compose ps

c:
	docker compose config



build:
	docker build \
		-t my_clojure \
		-f clojure/Dockerfile_Clojure \
		clojure/

clojure:
	docker run --rm -it \
		-v ./app/lib:/usr/src/app \
		--expose 8080 -p 8080:8080 \
		my_clojure



