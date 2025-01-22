

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
	cat ./config/msmtprc-template \
		| envsubst '$$ENV_NAME $$IPACS_DOMAIN_NAME' \
		> ./config/msmtprc

backup:
	docker exec -t --user root ph_system_php_$(ENV_NAME) bash /backup-papers.sh



