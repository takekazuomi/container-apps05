RESOURCE_GROUP				= omi01-rg
LOCATION				= canadacentral
LOG_ANALYTICS_WORKSPACE			= containerapps-logs
CONTAINERAPPS_ENVIRONMENT		= containerapps-env
LOG_ANALYTICS_WORKSPACE_CLIENT_ID	?= $(shell az monitor log-analytics workspace show --query customerId -g $(RESOURCE_GROUP) -n $(LOG_ANALYTICS_WORKSPACE) --out tsv)
LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET	?= $(shell az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $(RESOURCE_GROUP) -n $(LOG_ANALYTICS_WORKSPACE) --out tsv)
CR_NAME					?= ghcr.io
CR_USER					?= takekazuomi
IMAGE_NAME				?= $(CR_NAME)/$(CR_USER)/container-apps05
APP_FQDN				?= $(shell az containerapp show \
						--resource-group $(RESOURCE_GROUP) \
						--name my-container-app \
						--query configuration.ingress.fqdn \
						-o tsv)

help:		## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

setup: 			## initial setup. only for first time
setup: setup-azcli create-rg create-la create-env
	cd app; $(MAKE) ghcr-login

setup-azcli:
	az extension show -n containerapp -o none || \
	az extension add --upgrade \
	--source https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.0-py2.py3-none-any.whl

create-rg:		## create resouce group
	az group create \
	--name $(RESOURCE_GROUP) \
	--location "$(LOCATION)"

create-la:		## create log analytics
	az monitor log-analytics workspace create \
	--resource-group $(RESOURCE_GROUP) \
	--workspace-name $(LOG_ANALYTICS_WORKSPACE)

create-env:		## create containerapp environmnet
	az containerapp env create \
	--name $(CONTAINERAPPS_ENVIRONMENT) \
	--resource-group $(RESOURCE_GROUP) \
	--logs-workspace-id $(LOG_ANALYTICS_WORKSPACE_CLIENT_ID) \
	--logs-workspace-key $(LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET) \
	--location "$(LOCATION)"

app-create:		## create container apps
	az containerapp create \
	--name my-container-app \
	--resource-group $(RESOURCE_GROUP) \
	--environment $(CONTAINERAPPS_ENVIRONMENT) \
	--image $(IMAGE_NAME):latest \
	--target-port 8088 \
	--ingress 'external' \
	--query configuration.ingress.fqdn

app-list:		## list container apps
	az containerapp list \
	--resource-group $(RESOURCE_GROUP) \
	-o table

app-update:		## update container apps
	az containerapp update \
	--resource-group $(RESOURCE_GROUP) \
	--name my-container-app \
	--image $(IMAGE_NAME):latest \
	-o table

app-show:		## show container apps
	az containerapp show \
	--resource-group $(RESOURCE_GROUP) \
	--name my-container-app \
	-o table

app-fqdn:		## show container apps fqdn
	@echo $(APP_FQDN)

app-curl:		## curl container apps
	curl https://$(APP_FQDN)

app-delete:		## delete container apps
	az containerapp delete \
	--resource-group $(RESOURCE_GROUP) \
	--name my-container-app \
	-o table

build:			## build application
	cd app; $(MAKE) CR_NAME=$(CR_NAME) CR_USER=$(CR_USER) IMAGE_NAME=$(IMAGE_NAME) build push

