

.PHONY: build-template
build-template:
	jinja2 nginx-deployment-gke.yaml.jinja ../../gke_jinja.json --format=json > nginx-deployment-gke.yaml
	jinja2 nginx-deployment-minikube.yaml.jinja ../../minikube_jinja.json --format=json > nginx-deployment-minikube.yaml

.PHONY: nginx-up-mini
nginx-up-mini:
	kubectl create -f ./nginx-deployment-minikube.yaml
	kubectl create -f ./nginx-service.yaml

.PHONY: nginx-down-mini
nginx-down-mini:
	kubectl delete -f ./nginx-deployment-minikube.yaml
	kubectl delete -f ./nginx-service.yaml

.PHONY: nginx-up-gke
nginx-up-gke:
	kubectl create -f ./nginx-deployment-gke.yaml
	kubectl create -f ./nginx-service.yaml

.PHONY: nginx-down-gke
nginx-down-gke:
	kubectl delete -f ./nginx-deployment-gke.yaml
	kubectl delete -f ./nginx-service.yaml
