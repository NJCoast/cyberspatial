

.PHONY: build-template
build-template:
	jinja2 django-deployment.yaml.jinja ../../gke_jinja.json --format=json > django-deployment-gke.yaml
	jinja2 django-deployment.yaml.jinja ../../minikube_jinja.json --format=json > django-deployment-minikube.yaml

.PHONY: django-up
	kubectl create -f ./django-deployment-minikube.yaml
	kubectl create -f ./django-service.yaml

.PHONY: django-down
	kubectl delete -f ./django-deployment-minikube.yaml
	kubectl delete -f ./django-service.yaml
