

##
##
##

# -include .env_default
-include .env
export


help:	## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)



.PHONY: config
config:
	mkdir -p init/01_create
	echo "" > init/01_create/empty.sql


.PHONY: backup
backup:
	docker exec -t ph_system_pg_$(ENV_NAME) bash /backup-pg.sh




