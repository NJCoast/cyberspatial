.PHONY: all
all: django-up

.PHONY: build-template
build-template:
	jinja2 django-deployment.yaml.jinja ../../gke_jinja.json --format=json > django-deployment-gke.yaml
	jinja2 django-deployment.yaml.jinja ../../minikube_jinja.json --format=json > django-deployment-minikube.yaml

.PHONY: django-up-mini
django-up-mini:
	kubectl create -f ./django-deployment-minikube.yaml
	kubectl create -f ./django-service.yaml

.PHONY: django-down-mini
django-down-mini:
	kubectl delete -f ./django-deployment-minikube.yaml
	kubectl delete -f ./django-service.yaml

.PHONY: django-up-gke
django-up-gke:
	kubectl create -f ./django-deployment-gke.yaml
	kubectl create -f ./django-service.yaml

.PHONY: django-down-gke
django-down-gke:
	kubectl delete -f ./django-deployment-gke.yaml
	kubectl delete -f ./django-service.yaml
