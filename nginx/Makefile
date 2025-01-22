

##
##
##


# -include .env_default
-include .env
export

help:	## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)


config:

	cat ./default-template.conf \
		| envsubst '$$IPACS_DOMAIN_NAME $$COMS_DOMAIN_NAME $$CAP_DOMAIN_NAME $$LIB_DOMAIN_NAME $$CONF_DOMAIN_NAME $$ALBUM_DOMAIN_NAME' \
		> ./default.conf


